{
  config,
  lib,
  outputs,
  pkgs,
  ...
}: let
  cfg = config.erdtree.niscolas.bspwm;

  ewwWorkspacesBin = import ./scripts/eww-workspaces.nix {inherit pkgs;};
  kbLayoutSwapBin = import ../scripts/kb-layout-swap.nix {inherit pkgs;};
  launchEwwBarBin = import ../eww/launch-bar.nix {inherit pkgs;};
  restartStaloneTrayBin = import ../stalonetray/restart-bin.nix {inherit pkgs;};

  ewwBspcSubscribeBin = pkgs.writeShellScriptBin "eww-bspc-subscribe" ''
    bspc subscribe all | while read -r event; do
        ${ewwWorkspacesBin}/bin/my-bspwm-eww-workspaces
    done
  '';

  gruvboxTheme = pkgs.writeShellScriptBin "bspwm-gruvbox" ''
    bspc config focused_border_color "#FABD2F"
    bspc config normal_border_color "#32302F"
  '';

  defaultBg = pkgs.fetchurl {
    url = "https://media.githubusercontent.com/media/niscolas/wallpapers/main/static/gruvbox_skull-1920x1080.png";
    hash = "sha256-rhpd0jjBYE/sfHgSKaeHQDf/gmeyhD41unDZhnnxSsE=";
  };
in {
  imports = [outputs.homeManagerModules.wired];

  options.erdtree.niscolas.bspwm = {
    enable = lib.mkEnableOption {};
    debugMode = lib.mkEnableOption {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      []
      ++ (
        if cfg.debugMode
        then [bspwm]
        else []
      );

    xsession.windowManager.bspwm = {
      enable = !cfg.debugMode;

      settings = {
        # window behavior {{{
        border_width = 4;
        window_gap = 20;
        split_ratio = 0.52;
        # }}}

        # pointer behavior {{{
        focus_follows_pointer = false;
        pointer_follows_focus = true;
        # }}}

        # monocle {{{
        borderless_monocle = true;
        gapless_monocle = false;
        paddingless_monocle = true;
        single_monocle = false;
        # }}}
      };

      monitors = {
        eDP-1-1 = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "10"];
        HDMI-0 = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "10"];
      };

      startupPrograms = with pkgs; [
        "${wired}/bin/wired"
        "${xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr"
        "${xorg.setxkbmap}/bin/setxkbmap us"
        "${xorg.setxkbmap}/bin/setxkbmap -option 'compose:menu'"
        "${picom}/bin/picom"
        "${ewwBspcSubscribeBin}/bin/eww-bspc-subscribe"
        "${launchEwwBarBin}/bin/launch-eww-bar"
        "${restartStaloneTrayBin}/bin/my-stalonetray"
        "${feh}/bin/feh --bg-fill ${defaultBg}"
      ];

      extraConfig = with pkgs; ''
        pgrep -x ${sxhkd}/bin/sxhkd > /dev/null || ${sxhkd}/bin/sxhkd &

        ${gruvboxTheme}/bin/bspwm-gruvbox
      '';
    };

    xdg.configFile = {
      "sxhkd/sxhkdrc".text = ''
        #
        # wm independent hotkeys
        #

        super + shift + comma
          ${kbLayoutSwapBin}/bin/kb-layout-swap --swap

        # terminal emulator
        super + Return
          ${pkgs.alacritty}/bin/alacritty

        # program launcher
        super + space
          $HOME/.config/rofi/launchers/type-3/launcher.sh

        super + ctrl + p
          $HOME/.config/rofi/powermenu/type-2/powermenu.sh

        super + ctrl + v
          $HOME/.config/rofi/applets/bin/volume.sh

        # make sxhkd reload its configuration files:
        super + ctrl + s
          notify-send "reload config files" && pkill -USR1 -x sxhkd

        super + shift + x
          ${pkgs.flameshot}/bin/flameshot gui

        XF86Audio{Mute,RaiseVolume,LowerVolume}
        	amixer --nocheck set Master {toggle,5%+,5%-}

        #
        # bspwm hotkeys
        #

        # quit/restart bspwm
        super + shift + r
        	bspc wm -r

        # reload monitor setup
        super + shift + m
        	$SCRIPTS_DIR/bspwm/bspwm-full_auto_monitor_setup.sh

        # close and kill
        super + {_,shift + }q
        	bspc node -{c,k}

        # alternate between the tiled and monocle layout
        super + f
        	bspc desktop -l next

        # send the newest marked node to the newest preselected node
        super + y
        	bspc node newest.marked.local -n newest.!automatic.local

        # swap the current node and the biggest window
        super + g
        	bspc node -s biggest.window

        #
        # state/flags
        #

        # set the window state
        super + {t,shift + t,s,f}
        	bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

        # set the node flags
        super + ctrl + {m,x,y,z}
        	bspc node -g {marked,locked,sticky,private}

        #
        # focus/swap
        #

        # focus the node in the given direction
        super + {_,shift + }{h,j,k,l}
        	bspc node -{f,s} {west,south,north,east}

        # focus the node for the given path jump
        super + {p,b,comma,period}
        	bspc node -f @{parent,brother,first,second}

        # focus the next/previous window in the current desktop
        super + {_,shift + }c
        	bspc node -f {next,prev}.local.!hidden.window

        # focus the next/previous desktop in the current monitor
        super + bracket{left,right}
        	bspc desktop -f {prev,next}.local

        # focus the last node/desktop
        super + {grave,Tab}
        	bspc {node,desktop} -f last

        # focus the older or newer node in the focus history
        super + {o,i}
        	bspc wm -h off; \
        	bspc node {older,newer} -f; \
        	bspc wm -h on

        # focus or send to the given desktop
        super + {_,shift + }{1-9,0}
        	bspc {desktop -f,node -d} 'focused:^{1-9,10}'

        #
        # preselect
        #

        # preselect the direction
        super + ctrl + {h,j,k,l}
        	bspc node -p {west,south,north,east}

        # preselect the ratio
        super + ctrl + {1-9}
        	bspc node -o 0.{1-9}

        # cancel the preselection for the focused node
        super + ctrl + space
        	bspc node -p cancel

        # cancel the preselection for the focused desktop
        super + ctrl + shift + space
        	bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

        #
        # move/resize
        #

        # expand a window by moving one of its side outward
        super + alt + {h,j,k,l}
        	bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

        # contract a window by moving one of its side inward
        super + alt + shift + {h,j,k,l}
        	bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}

        # move a floating window
        super + {Left,Down,Up,Right}
        	bspc node -v {-20 0,0 20,0 -20,20 0}
      '';
    };

    erdtree.wired = {
      enable = true;
      enableDebugMode = true;
    };
  };
}
