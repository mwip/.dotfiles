# heavily influenced by
# https://github.com/qtile/qtile-examples/blob/82bb924d29c2669c13b157dd7d9c0d66b9389843/osimplex/bindings.py

from libqtile.config import Key, Drag, Click
from libqtile.command import lazy

from functions import Function


class Keys(object):

    def init_keys(self, my_term, script_path, mod):

        return [ 
            # Window manager controls
            Key([mod, 'control'], 'r', lazy.restart()),
            # Key([mod, 'control'], 'q', lazy.shutdown()),
            Key([mod], 'r', lazy.spawn(script_path + 'dmenu_recent.sh')),
            Key([mod, "mod1"], 'r', lazy.spawn(script_path + 'dmenu_removeRecent.sh')),
            Key([mod], 'Return', lazy.spawn(my_term)),
            Key([mod], 'q',      lazy.window.kill()),
            
            Key([mod], 'Tab', lazy.layout.next()),
            #Key([mod], 'Left', lazy.screen.prev_group()),
            #Key([mod], 'Right', lazy.screen.next_group()),
            Key([mod], "Left", lazy.prev_screen()),
            Key([mod], "Right", lazy.next_screen()),
            Key([mod, "shift"], "Left", Function.window_to_prev_screen()),
            Key([mod, "shift"], "Right", Function.window_to_next_screen()),
            
            # Layout modification
            Key([mod, 'control'], 'f', lazy.window.toggle_floating()),
            
            # Switch between windows in current stack pane
            Key([mod], 'k', lazy.layout.down()),
            Key([mod], 'j', lazy.layout.up()),
            
            # Move windows up or down in current stack
            Key([mod, 'shift'], 'k', lazy.layout.shuffle_down()),
            Key([mod, 'shift'], 'j', lazy.layout.shuffle_up()),
            
            # Switch window focus to other pane(s) of stack
            # Key([mod], 'space', lazy.layout.next()),
            Key([mod], 'space', lazy.spawn(script_path + 'dmenu_recent.sh')),
            
            # Toggle between different layouts as defined below
            Key([mod], 'Tab',    lazy.next_layout()),
            
            #############################################################################
            # Own shortcuts                                                             #
            #############################################################################
            # # emacs
            Key(['control', 'mod1'], 'e', lazy.spawn('emacs')),
            # pcmanfm 
            Key([mod], 'e', lazy.spawn(script_path + 'dmenu_filemanager.sh')),
            # firefox
            Key([mod, 'control'], 'Return', lazy.spawn('firefox')),
            # logout
            Key([mod, 'shift'], 'q', lazy.spawn(script_path + 'dmenu_exit.sh')),
            Key([mod], 'l', lazy.spawn(script_path + 'lockscreen.sh')),
            # brightness control
            Key([], 'XF86MonBrightnessDown', lazy.spawn(script_path + 'brightness.sh -')),
            Key([], 'XF86MonBrightnessUp', lazy.spawn(script_path + 'brightness.sh +')),
            # volume control
            Key([], 'XF86AudioRaiseVolume', lazy.spawn(script_path + 'adjust_volume.sh +')),
            Key([], 'XF86AudioLowerVolume', lazy.spawn(script_path + 'adjust_volume.sh -')),
            Key([], 'XF86AudioMute', lazy.spawn(script_path + 'adjust_volume.sh m')),
            # screenshots
            Key([mod], 's', lazy.spawn(script_path + 'screenshot_full.sh')),
            Key([mod, 'shift'], 's', lazy.spawn(script_path + 'screenshot_region.sh')),
            Key([], 'XF86AudioPlay', lazy.spawn(script_path + 'mpc_playpause.sh')), 
            Key([], 'XF86AudioNext', lazy.spawn('mpc next')), 
            Key([], 'XF86AudioPrev', lazy.spawn('mpc prev')),
            # screens and monitors
            Key([mod], 'p', lazy.spawn(script_path + 'dmenu_displayselect.sh')),
            
        ]
    
class Mouses(object):
    
    def init_mouse(self):

        mod = "mod4"

        return [
            Drag([mod], 'Button1', lazy.window.set_position_floating(),
                 start=lazy.window.get_position()),
            Drag([mod], 'Button3', lazy.window.set_size_floating(),
                 start=lazy.window.get_size())
        ]
