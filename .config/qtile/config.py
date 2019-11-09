import os, subprocess, socket
from libqtile import bar, hook, layout, widget #, extension
from libqtile.command import lazy, Client
from libqtile.config import Click, Drag, Group, Key, Screen
import batterystatus

wmname = 'LG3D'
mod = 'mod4'
my_gaps = 15
my_term = 'urxvtc'

##### DEFINING SOME WINDOW FUNCTIONS #####

@lazy.function
def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)

@lazy.function
def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)

# logout with dmenu check for security
@lazy.function
def exit_menu(qtile):
    cmd = os.path.expanduser('~/.config/qtile/dmenu_exit.sh')
    os.system(cmd)

def window_to_prev_group():
    @lazy.function
    def __inner(qtile):
        if qtile.currentWindow is not None:
            index = qtile.groups.index(qtile.currentGroup)
            if index > 0:
                qtile.currentWindow.togroup(qtile.groups[index - 1].name)
            else:
                qtile.currentWindow.togroup(qtile.groups[len(qtile.groups) - 2].name)

    return __inner


def window_to_next_group():
    @lazy.function
    def __inner(qtile):
        if qtile.currentWindow is not None:
            index = qtile.groups.index(qtile.currentGroup)
            if index < len(qtile.groups) - 2:
                qtile.currentWindow.togroup(qtile.groups[index + 1].name)
            else:
                qtile.currentWindow.togroup(qtile.groups[0].name)

    return __inner


def window_to_prev_screen():
    @lazy.function
    def __inner(qtile):
        if qtile.currentWindow is not None:
            index = qtile.screens.index(qtile.currentScreen)
            if index > 0:
                qtile.currentWindow.togroup(qtile.screens[index - 1].group.name)
            else:
                qtile.currentWindow.togroup(qtile.screens[len(qtile.screens) - 1].group.name)

    return __inner


def window_to_next_screen():
    @lazy.function
    def __inner(qtile):
        if qtile.currentWindow is not None:
            index = qtile.screens.index(qtile.currentScreen)
            if index < len(qtile.screens) - 1:
                qtile.currentWindow.togroup(qtile.screens[index + 1].group.name)
            else:
                qtile.currentWindow.togroup(qtile.screens[0].group.name)

    return __inner


def go_to_next_group():
    @lazy.function
    def __inner(qtile):
        index = qtile.groups.index(qtile.currentGroup)
        if index < len(qtile.groups) - 2:
            qtile.groups[index + 1].cmd_toscreen()
        else:
            qtile.groups[0].cmd_toscreen()

    return __inner


def go_to_prev_group():
    @lazy.function
    def __inner(qtile):
        index = qtile.groups.index(qtile.currentGroup)
        if index > 0:
            qtile.groups[index - 1].cmd_toscreen()
        else:
            qtile.groups[len(qtile.groups) - 2].cmd_toscreen()

    return __inner

def poll_battery():
#     return "test"
    return batterystatus.battery_status()

# Key bindings
keys = [
    # Window manager controls
    Key([mod, 'control'], 'r', lazy.restart()),
    # Key([mod, 'control'], 'q', lazy.shutdown()),
    Key([mod], 'r', lazy.spawn('dmenu_run -fn "Ubuntu Mono-14"')),
    Key([mod], 'Return', lazy.spawn(my_term)),
    Key([mod], 'q',      lazy.window.kill()),

    Key([mod], 'Tab', lazy.layout.next()),
    #Key([mod], 'Left', lazy.screen.prev_group()),
    #Key([mod], 'Right', lazy.screen.next_group()),
    Key([mod], "Left", lazy.prev_screen()),
    Key([mod], "Right", lazy.next_screen()),
    Key([mod, "shift"], "Left", window_to_prev_screen()),
    Key([mod, "shift"], "Right", window_to_next_screen()),

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
    Key([mod], 'space', lazy.spawn('dmenu_run -fn "Ubuntu Mono-14"')),

    # Toggle between different layouts as defined below
    Key([mod], 'Tab',    lazy.next_layout()),

    #############################################################################
    # Own shortcuts                                                             #
    #############################################################################
    # resizing windows
    # Key([mod, "control"], "j", lazy.layout.grow_down()),
    # Key([mod, "control"], "k", lazy.layout.grow_up()),
    # Key([mod, "control"], "h", lazy.layout.grow_left()),
    # Key([mod, "control"], "l", lazy.layout.grow_right()),
    # # emacs
    Key(['control', 'mod1'], 'e', lazy.spawn('emacs')),
    # Key(['control', mod], 'n', lazy.switch_screen()),
    # pcmanfm 
    Key([mod], 'e', lazy.spawn('/home/loki/.config/qtile/dmenu_filemanager.sh')),
    # firefox
    Key([mod, 'control'], 'Return', lazy.spawn('firefox')),
    # logout
    Key([mod, 'shift'], 'q', lazy.spawn("/home/loki/.config/qtile/dmenu_exit.sh")),
    Key([mod], 'l', lazy.spawn("/home/loki/.config/qtile/lockscreen.sh")),
    Key([], 'XF86MonBrightnessDown', lazy.spawn('/home/loki/.config/qtile/brightness.sh -')),
    Key([], 'XF86MonBrightnessUp', lazy.spawn('/home/loki/.config/qtile/brightness.sh +')),
    Key([], 'XF86AudioRaiseVolume', lazy.spawn('/home/loki/.config/qtile/adjust_volume.sh +')),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('/home/loki/.config/qtile/adjust_volume.sh -')),
    
]

# Mouse bindings and options
mouse = (
    Drag([mod], 'Button1', lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag([mod], 'Button3', lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
)

bring_front_click = True
cursor_warp = False
follow_mouse_focus = True

# Groups
groups = [
    Group('1', label = '1:'),#, matches = Match(title=["Firefox"])),
    Group('2', label = '2:'),#, matches = Match(title=["emacs"])),
    Group('3', label = '3:'),
    Group('4', label = '4:'),
    Group('5', label = '5:'),
    Group('6', label = '6:'),
    Group('7', label = '7:'),
    Group('8', label = '8:'),
    Group('9', label = '9:')
]

for i in groups:
    # mod + letter of group = switch to group
    keys.append(Key([mod], i.name, lazy.group[i.name].toscreen()))
    # mod + shift + letter of group = switch to & move focused window to group
    keys.append(Key([mod, 'shift'], i.name, lazy.window.togroup(i.name)))

dgroups_key_binder = None
dgroups_app_rules = []

# Layouts
layouts = [
    layout.MonadTall(
	border_width = 2, 
	single_border_width = 2, 
        margin = my_gaps, 
	),
    layout.MonadWide(
        border_width = 2,
        single_border_width = 2,
        margin = my_gaps,
    ),
    layout.Matrix(
        border_width = 2,
        single_border_width = 2,
        margin = my_gaps,
    ),
    layout.TreeTab(),
    layout.Floating(),
]

floating_layout = layout.Floating()

def init_widgets_list():
    prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
    widget_list = [
        widget.CurrentScreen(
            active_text = "",
            active_color = "FF0000",
            inactive_text = "",
            inactive_color = "222222",
            font = "Ubuntu Mono Nerd Font",
            fontsize = 16,
        ),
        widget.Sep(
            linewidth = 1,
            padding = 5),
        widget.GroupBox(
            highlight_method = 'line',
            this_screen_border = '805300',
            this_current_screen_border = '805300',
            active = 'e69500',
            inactive = '555555',
            font = "Ubuntu Mono Nerd Font",
            fontsize = 16,
        ),
        widget.Sep(
            linewidth = 1,
            padding = 5),
        widget.TaskList(
            highlight_method = "block",
            fontsize = 12,
            border = '805300',
            font = "Ubuntu Mono Nerd Font"
        ),
        widget.Sep(
            linewidth = 1,
            padding = 5),
        widget.TextBox(""),
        widget.CPUGraph(
            fill_color = "e69500.3",
            graph_color = 'e69500',
            border_color = '805300',
            font = "Ubuntu Mono Nerd Font",
            fontsize = 16,
        ),
        widget.TextBox(""),
        widget.MemoryGraph(
            fill_color = "e69500.3",
            graph_color = 'e69500',
            border_color = '805300',
            font = "Ubuntu Mono Nerd Font",
            fontsize = 16,
        ),
        # widget.TextBox(""),
        # widget.NetGraph(
        #     fill_color = "e69500.3",
        #     graph_color = 'e69500',
        #     border_color = '805300'
        # ),
        widget.Sep(
            linewidth = 1,
            padding = 5),
        widget.Systray(
            padding = 5
        ),
        widget.Sep(
            padding = 5,
            linewidth = 1,
        ),
        widget.BatteryIcon(
            fontsize = 0,
            update_interval = 5
        ),
        widget.GenPollText(
            func = poll_battery,
            update_interval = 5,
            font = "Ubuntu Mono Nerd Font",
        ),
        widget.Sep(
            linewidth = 1,
            padding = 5),
        widget.CurrentLayout(
            font = "Ubuntu Mono Nerd Font",
            fontsize = 16,
        ),
        widget.Sep(
            linewidth = 1,
            padding = 5),
        widget.Clock(
            format = "%Y-%m-%d - %H:%M:%S",
            font = "Ubuntu Mono Nerd Font",
            fontsize = 16,
        )
    ]
    return widget_list

def init_widgets_screen1():
    wdgs1 = init_widgets_list()
    return wdgs1

def init_widgets_screen2():
    wdgs2 = init_widgets_list()
    return wdgs2

def init_widgets_screen3():
    wdgs3 = init_widgets_list()
    return wdgs3


# Screens and widget options
screens = [
    Screen(top=bar.Bar(widgets = init_widgets_screen1(),
                       opacity = 0.95, size = 22)), 
    # Screen(top=bar.Bar(widgets = init_widgets_screen2(),
    #                    opacity = 0.95, size = 22)),
    # Screen(top=bar.Bar(widgets = init_widgets_screen3(),
    #                    opacity = 0.95, size = 22)),
]

widget_defaults = dict(
    font='Ubuntu Mono Nerd',
    fontsize=15,
)

auto_fullscreen = True

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])

def main(qtile):
    ''' This function is called when Qtile starts. '''
    pass
