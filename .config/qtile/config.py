import socket
from os.path import expanduser
from subprocess import run
from copy import deepcopy
from libqtile import bar, layout, widget, hook, extension
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown, KeyChord
from libqtile.lazy import lazy

MOD = "mod4"
TERMINAL = "alacritty"
MYFONT = "Hack Nerd Font Mono"
HOST = socket.gethostname()
HOME = "/home/loki"
SCRIPTS = f"{HOME}/.scripts"


@hook.subscribe.startup_once
def autostart():
    run([expanduser("~/.config/qtile/autostart.sh")])


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([MOD], "j", lazy.layout.down(), desc="Move focus down"),
    Key([MOD], "k", lazy.layout.up(), desc="Move focus up"),
    Key([MOD], "t", lazy.window.toggle_floating()),
    Key([MOD], "b", lazy.hide_show_bar()),
    Key([MOD], "w", lazy.spawn("rofi -show window -show-icons -matching fuzzy")),
    Key([MOD], "q", lazy.window.kill()),
    # Toggle between different layouts as defined below
    Key([MOD], "space", lazy.next_layout(), desc="Toggle between layouts"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([MOD, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key(
        [MOD, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([MOD, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([MOD, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([MOD], "l", lazy.layout.grow_main(), desc="Grow main"),
    Key([MOD], "h", lazy.layout.shrink_main(), desc="Shrink Master"),
    Key([MOD, "control"], "j", lazy.layout.shrink(), desc="Grow window down"),
    Key([MOD, "control"], "k", lazy.layout.grow(), desc="Grow window up"),
    # maximize and reset
    Key([MOD], "m", lazy.layout.maximize(), desc="Maximize Master"),
    Key([MOD], "n", lazy.layout.reset(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [MOD, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([MOD], "Return", lazy.spawn(TERMINAL), desc="Launch terminal"),
    Key([MOD, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([MOD, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # spawn applications
    Key(
        [MOD],
        "r",
        lazy.run_extension(
            extension.DmenuRun(
                dmenu_prompt=">>>",
                dmenu_command="dmenu_recent.sh",
                dmenu_font=MYFONT,
                # dmenu_height=16,
                dmenu_ignorecase=True,
                foreground="#D0D0D0",
                background="#242730",
                selected_foreground="#444444",
                selected_background="#C45500",
            )
        ),
        desc="Spawn a command using a prompt widget",
    ),
    Key([MOD], "f", lazy.spawn("librewolf"), desc="Launch Firefox"),
    # Emacs KeyChords
    KeyChord(
        [MOD],
        "e",
        [
            Key([], "e", lazy.spawn("emacsclient -c -a 'emacs'"), desc="Launch Emacs"),
            Key([], "m", lazy.spawn("emacsclient -c -a 'emacs' -e '(mu4e)'"), desc="Launch mu4e"),
            Key(
                [],
                "c",
                lazy.spawn("emacsclient -c -a 'emacs' -e '(org-capture)'"),
                desc="Launch org capture",
            ),
            Key([], "q", lazy.spawn(f"{SCRIPTS}/restart_emacs.sh")),
        ],
    ),
    # Media controls
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume 0 +5%"),
        lazy.spawn("mpv /tmp/avc.wav"),
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume 0 -5%"),
        lazy.spawn("mpv /tmp/avc.wav"),
    ),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("pactl set-sink-mute 0 toggle"),
        lazy.spawn("mpv /tmp/avc.wav"),
    ),
    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight + 10 -time 0")),
    Key([MOD, "shift"], "c", lazy.spawn(f"{SCRIPTS}/xcolor_pick.sh")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight - 10 -time 0")),
    # scratchpads
    Key([MOD], "F11", lazy.group["scratchpad"].dropdown_toggle("qalc")),
    Key([MOD], "F12", lazy.group["scratchpad"].dropdown_toggle("cal")),
]

groups = [
    Group("1", label="1:", layout="max", matches=[Match(wm_class=["librewolf"])]),
    Group("2", label="2:", layout="max", matches=[Match(wm_class=["Emacs"])]),
    Group("3", label="3:", layout="monadtall"),
    Group("4", label="4:", layout="max"),
    Group("5", label="5:", layout="max"),
    Group("6", label="6:ﱘ", layout="monadtall"),
    Group("7", label="7:", layout="floating"),
    Group("8", label="8:", layout="max"),
    Group("9", label="9:", layout="max"),
    Group("0", label="0:", layout="monadtall"),
    Group("ssharp", label="ß:", layout="floating"),
]

# groups = [Group(i) for i in "123456789"]

for group in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [MOD],
                group.name,
                lazy.group[group.name].toscreen(),
                desc="Switch to group {}".format(group.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [MOD, "shift"],
                group.name,
                lazy.window.togroup(group.name, switch_group=False),
                desc="Switch to & move focused window to group {}".format(group.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([MOD, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

groups += [
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "cal",
                "alacritty -t calendar --hold -e /usr/bin/cal -y",
                opacity=0.8,
                height=0.8,
                width=0.4,
                x=0.3,
                y=0.1,
                on_focus_lost_hide=False,
            ),
            DropDown(
                "qalc",
                "alacritty -t qalc --hold -e /usr/bin/qalc",
                opacity=0.8,
                on_focus_lost_hide=False,
            ),
        ],
    ),
]

layouts = [
    layout.MonadTall(margin=6),
    layout.Max(),
    layout.Floating(),
]

widget_defaults = dict(
    font=MYFONT,
    fontsize=14,
    foreground="#bbc2cf",
    fgcolor_normal="#bbc2cf",
    padding=5,
)

extension_defaults = widget_defaults.copy()

mywidgets = []
# Groups
mywidgets.extend(
    [
        widget.GroupBox(
            padding=1,
            font=MYFONT,
            disable_drag=True,
            highlight_method="text",
            highlight_color="#e69055",
            active="#1f5582",
            this_current_screen_border="#e69055",
            this_screen_border="#e69055",
            other_screen_border="#7bc275",
            other_current_screen_border="#7bc275",
        )
    ]
)
# Layout
mywidgets.extend([widget.Sep(), widget.CurrentLayout()])
# Window title
mywidgets.extend([widget.Sep(), widget.WindowName()])

# andlang specific
if HOST == "andlang":
    # mpd
    widget.Mpd2()

# Network usage
mywidgets.extend([widget.Sep(), widget.Net(format=" {down} ↓↑ {up}"), widget.NetGraph()])
# Temperature
mywidgets.extend([widget.Sep(), widget.ThermalZone()])

# bifrost specific
if HOST == "bifrost":
    # Battery
    mywidgets.extend(
        [
            widget.Sep(),
            widget.BatteryIcon(),
            widget.Battery(format="{char} {percent:2.0%} {hour:d}:{min:02d}h"),
        ]
    )
    # Backlight
    mywidgets.extend(
        [
            widget.Sep(),
            widget.Backlight(
                brightness_file="/sys/class/backlight/intel_backlight/brightness",
                max_brightness_file="/sys/class/backlight/intel_backlight/max_brightness",
                fmt=" {}",
            ),
        ]
    )

# Audio level
mywidgets.extend(
    [
        widget.Sep(),
        widget.Volume(
            fmt="墳 {}",
            # get_volume_command="pulsemixer --get-volume | awk '{print $1}'",
            update_interval=0.2,
        ),
    ]
)
# Time
mywidgets.extend([widget.Sep(), widget.Clock(format="%Y-%m-%d %a %H:%M")])
# Systray
mywidgets.extend(
    [
        widget.Sep(),
        widget.Systray(padding=0),
    ]
)

screens = [Screen(top=bar.Bar(widgets=mywidgets, size=24, background="#242730"))]

# Drag floating layouts.
mouse = [
    Drag([MOD], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([MOD], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([MOD], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = "floating_only"
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="KeePassXC"),
        Match(title="Copying"),
        Match(title="Copy file(s)"),
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# java that happens to be on java's whitelist.
wmname = "LG3D"
