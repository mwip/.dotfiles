import os, subprocess
from libqtile import bar, hook, layout
from libqtile.config import Screen

# own classes and function scripts
from rules import Rules
from widgets import Widgets
from functions import Function
from bindings import Keys, Mouses
from layouts import Layouts
from groups import Groups
import batterystatus
import get_brightness

mod = 'mod4'
my_gaps = 15
my_term = 'urxvtc'
script_path = os.path.expanduser('~/.scripts/')
hostname = subprocess.run(['hostname'], stdout = subprocess.PIPE).stdout.decode('utf-8').replace('\n', '')


wmname = 'LG3D'
bring_front_click = True
cursor_warp = False
follow_mouse_focus = True
auto_fullscreen = True


# Groups
obj_groups = Groups()
groups = obj_groups.init_groups()


# Key bindings
obj_keys = Keys()
keys = obj_keys.init_keys(my_term, script_path, mod)
# Mouse bindings and options
obj_mouse = Mouses()
mouse = obj_mouse.init_mouse()

# group key bindings
keys = Groups.add_group_key_bindings(groups, keys, mod)

obj_rules = Rules()
dgroups_app_rules = obj_rules.init_rules()
dgroups_key_binder = None

# Layouts
obj_layouts = Layouts()
layouts = obj_layouts.init_layouts(my_gaps)
floating_layout = layout.Floating()

# Widgets
whichPrimary = {
    'bifrost': [True, False, False],
    'walhall': [False, True, False]
}
my_widgets1 = Widgets(hostname, primaryMonitor = whichPrimary[hostname][0])
my_widgets2 = Widgets(hostname, primaryMonitor = whichPrimary[hostname][1])
#my_widgets3 = Widgets(hostname, primaryMonitor = whichPrimary[hostname][2])

# Screens with Widgets
screens = [
    Screen(top=bar.Bar(widgets = my_widgets1.init_widgets(),
                       opacity = 0.95, size = 22)), 
    Screen(top=bar.Bar(widgets = my_widgets2.init_widgets(),
                       opacity = 0.95, size = 22)),
    # Screen(top=bar.Bar(widgets = init_widgets_screen3(),
    #                    opacity = 0.95, size = 22)),
]

# Autostart hook
@hook.subscribe.startup_once
def autostart():
    home = script_path + 'autostart.sh'
    subprocess.call([home])

def main(qtile):
    ''' This function is called when Qtile starts. '''
    pass
