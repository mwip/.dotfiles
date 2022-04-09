from os.path import expanduser
from subprocess import run
from copy import deepcopy
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy

MOD = "mod4"
terminal = "alacritty"


@hook.subscribe.startup_once
def autostart():
    run([expanduser("~/.config/qtile/autostart.sh")])


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([MOD], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([MOD], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([MOD], "j", lazy.layout.down(), desc="Move focus down"),
    Key([MOD], "k", lazy.layout.up(), desc="Move focus up"),
    Key([MOD], "t", lazy.window.toggle_floating()),
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
    Key([MOD], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([MOD, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([MOD, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # spawn applications
    Key(
        [MOD],
        "r",
        lazy.spawn(
            "dmenu_run -i -fn 'Hack Nerd Font Mono:size=16' -nb '#161616' -nf '#D0D0D0' -sf '#444444' -sb '#C45500'"
        ),
        desc="Spawn a command using a prompt widget",
    ),
    Key([MOD], "f", lazy.spawn("librewolf"), desc="Launch Firefox"),
    # Media controls
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume 0 +5%")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume 0 -5%")),
    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight + 10 -time 0")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight - 10 -time 0")),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute 0 toggle")),
    Key([], "F11", lazy.group["scratchpad"].dropdown_toggle("qalc")),
    Key([], "F12", lazy.group["scratchpad"].dropdown_toggle("cal")),
]

groups = [
    Group("1", label="1:", layout="max", matches=Match(wm_class=["Firefox"])),
    Group("2", label="2:", layout="max", matches=Match(title=["emacs@*"])),
    Group("3", label="3:", layout="monadtall"),
    Group("4", label="4:", layout="max"),
    Group("5", label="5:", layout="max"),
    Group("6", label="6:ﱘ", layout="monadtall"),
    Group("7", label="7:", layout="floating"),
    Group("8", label="8:"),
    Group("9", label="9:"),
    Group("0", label="0:"),
]

# groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [MOD],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [MOD, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc="Switch to & move focused window to group {}".format(i.name),
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
    layout.Matrix(margin=6, border_focus="#ff0000", border_width=2),
]

widget_defaults = dict(
    font="Hack Nerd Font Mono",
    fontsize=14,
    padding=5,
)

extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            widgets=[
                widget.GroupBox(disable_drag=True, highlight_method="line"),
                widget.Sep(),
                widget.CurrentLayout(),
                widget.Sep(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Sep(),
                widget.Net(),
                widget.Sep(),
                widget.ThermalZone(),
                widget.Sep(),
                widget.BatteryIcon(),
                widget.Battery(format="{char} {percent:2.0%} {hour:d}:{min:02d}h"),
                widget.Sep(),
                widget.PulseVolume(
                    fmt="Vol: {}",
                    get_volume_command="pulsemixer --get-volume | awk '{print $1}'",
                ),
                widget.Sep(),
                widget.Backlight(
                    brightness_file="/sys/class/backlight/intel_backlight/brightness",
                    max_brightness_file="/sys/class/backlight/intel_backlight/max_brightness",
                ),
                widget.Sep(),
                widget.Clock(format="%Y-%m-%d %a %H:%M"),
                widget.Sep(),
                widget.QuickExit(default_text="[shutdown]", countdown_format="[{} seconds]"),
                widget.Sep(),
                widget.Systray(),
            ],
            size=24,  # height of bar
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [MOD],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
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
