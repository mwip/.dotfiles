import socket
from os.path import expanduser
from subprocess import run
from copy import deepcopy
from libqtile import bar, layout, widget, hook, extension
from libqtile.config import Click, Drag, DropDown, Group, Key, Match, Screen, ScratchPad, KeyChord
from libqtile.lazy import lazy
import xmonad

MOD = "mod4"
ALT = "mod1"
SHIFT = "shift"
CTRL = "control"
TERMINAL = "alacritty"
MYFONT = "Code New Roman Nerd Font Mono"  # "Hack Nerd Font Mono" "Ubuntu Mono Nerd Font"
HOST = socket.gethostname()
HOME = "/home/loki"
SCRIPTS = f"{HOME}/.scripts"


@hook.subscribe.startup_once
def autostart():
    run([expanduser("~/.config/qtile/autostart.sh")])


keys = [
    #
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # windows
    Key([MOD], "j", lazy.layout.down()),
    Key([MOD, CTRL], "j", lazy.group.next_window()),
    Key([MOD], "k", lazy.layout.up()),
    Key([MOD, CTRL], "k", lazy.group.prev_window()),
    Key([MOD], "l", lazy.layout.grow_master(), desc="Grow main"),
    Key([MOD], "h", lazy.layout.shrink_master(), desc="Shrink main"),
    Key([MOD, ALT], "j", lazy.layout.shrink(), desc="Grow window down"),
    Key([MOD, ALT], "k", lazy.layout.grow(), desc="Grow window up"),
    Key([MOD, SHIFT], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([MOD, SHIFT], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([MOD, SHIFT], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([MOD, SHIFT], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([MOD], "i", lazy.layout.increase_nmaster()),
    Key([MOD], "d", lazy.layout.decrease_nmaster()),
    Key([MOD], "t", lazy.window.toggle_floating()),
    Key([MOD], "w", lazy.spawn("rofi -show window -show-icons -matching fuzzy")),
    Key([MOD], "q", lazy.window.kill()),
    #
    # maximize and reset
    Key([MOD], "m", lazy.layout.maximize(), desc="Maximize Master"),
    Key([MOD], "n", lazy.layout.reset(), desc="Reset all window sizes"),
    #
    # bar
    Key([MOD], "b", lazy.hide_show_bar()),
    #
    # Screens
    Key([MOD], "o", lazy.next_screen()),
    # Key([MOD, "shift"], "o", lazy.to_next_screen())  # see swap groups
    #
    # Groups
    Key([MOD], "space", lazy.next_layout(), desc="Toggle between layouts"),
    Key([MOD], "Page_Up", lazy.screen.prev_group()),
    Key([MOD], "Page_Down", lazy.screen.next_group()),
    # swap groups:
    # lazy.screen.toggle_group() should to it but you would probably will need to pass the ogher group name as the 'group_name' parameter
    # Key([MOD], "x", lazy.next_screen()),
    #
    # Qtile
    Key([MOD, CTRL], "r", lazy.reload_config(), desc="Reload the config"),
    Key([MOD, CTRL, SHIFT], "r", lazy.restart(), desc="Restart Qtile"),
    Key([MOD, CTRL], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([MOD, SHIFT], "q", lazy.spawn(f"{SCRIPTS}/dmenu_exit.sh"), desc="Shutdown Qtile"),
    #
    # spawn applications
    Key([MOD], "Return", lazy.spawn(TERMINAL), desc="Launch terminal"),
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
    #
    #
    # Applications
    Key([MOD], "f", lazy.spawn("librewolf"), desc="Launch Firefox"),
    Key([MOD, SHIFT], "c", lazy.spawn(f"{SCRIPTS}/xcolor_pick.sh")),
    Key([MOD, CTRL, SHIFT], "p", lazy.spawn("keepassxc")),
    # Meh
    Key(
        [CTRL, SHIFT, ALT],
        "m",
        lazy.spawn(f"{TERMINAL} -t ncmpcpp -e sh -c 'while true; do ncmpcpp; done'"),
    ),
    Key([CTRL, SHIFT, ALT], "q", lazy.spawn("qgis")),
    Key([CTRL, SHIFT, ALT], "r", lazy.spawn("rstudio-bin")),
    Key([CTRL, SHIFT, ALT], "a", lazy.spawn("pavucontrol")),
    Key([CTRL, SHIFT, ALT], "s", lazy.spawn("signal-desktop")),
    Key([CTRL, SHIFT, ALT], "b", lazy.spawn("blueman-manager")),
    #
    #
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
    #
    #
    # Media controls
    Key([], "XF86AudioPlay", lazy.spawn("mpc toggle")),
    Key([], "XF86AudioNext", lazy.spawn("mpc next")),
    Key([], "XF86AudioPrev", lazy.spawn("mpc prev")),
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
    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight + 10 -time 0")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight - 10 -time 0")),
    #
    #
    # scratchpads
    Key([MOD], "F11", lazy.group["scratchpad"].dropdown_toggle("qalc")),
    Key([MOD], "F12", lazy.group["scratchpad"].dropdown_toggle("cal")),
]

match_8 = [
    Match(
        wm_class=[
            "org.jabref.JabRefMain",
            "libreoffice",
            "libreoffice-startcenter",
            "libreoffice-calc",
            "libreoffice-draw",
            "libreoffice-impress",
            "libreoffice-writer",
        ]
    )
]

groups = [
    Group("1", label="1:", layout="max", matches=[Match(wm_class=["librewolf", "Chromium"])]),
    Group("2", label="2:", layout="max", matches=[Match(wm_class=["Emacs"])]),
    Group("3", label="3:", layout="monadtall"),
    Group("4", label="4:", layout="max", matches=[Match(wm_class=["RStudio"])]),
    Group("5", label="5:", layout="max", matches=[Match(wm_class=["Doublecmd", "Pcmanfm"])]),
    Group("6", label="6:ﱘ", layout="monadtall", matches=[Match(title=["ncmpcpp"])]),
    Group("7", label="7:", layout="floating", matches=[Match(wm_class=["QGIS3"])]),
    Group("8", label="8:", layout="max", matches=match_8),
    Group("9", label="9:", layout="max", matches=[Match(wm_class=["Gimp", "Inkscape"])]),
    Group("0", label="0:", layout="monadtall", matches=[Match(wm_class=["Signal"])]),
    Group("ssharp", label="ß:", layout="floating", matches=[Match(wm_class=["Steam"])]),
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
                [MOD, SHIFT],
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
                f"{TERMINAL} -t calendar --hold -e /usr/bin/cal -y",
                opacity=0.8,
                height=0.8,
                width=0.4,
                x=0.3,
                y=0.1,
                on_focus_lost_hide=False,
            ),
            DropDown(
                "qalc",
                f"{TERMINAL} -t qalc --hold -e /usr/bin/qalc",
                opacity=0.8,
                on_focus_lost_hide=False,
            ),
        ],
    ),
]

layout_kwargs = dict(
    border_focus="#C45500",
    border_width=2,
    margin=6,
)
layouts = [
    xmonad.MonadTall(new_client_position="after_current", **layout_kwargs),
    layout.Max(**layout_kwargs),
    layout.Floating(**layout_kwargs),
]

widget_defaults = dict(
    font=f"{MYFONT} Bold",
    fontsize=14,
    foreground="#bbc2cf",
    fgcolor_normal="#bbc2cf",
    fgcolor_high="#e6b155",
    fgcolor_crit="#dd5262",
    padding=5,
    update_interval=1,
)

extension_defaults = widget_defaults.copy()


# Widgets #########
# Groups
def w_f_groupbox():
    return widget.GroupBox(
        padding=1,
        disable_drag=True,
        highlight_method="line",
        highlight_color="#e69055",
        active="#1f5582",
        this_current_screen_border="#e69055",
        this_screen_border="#e69055",
        other_screen_border="#7bc275",
        other_current_screen_border="#7bc275",
    )


# separator
w_sep = widget.Sep()
# Layout
w_layout = widget.CurrentLayout()
# Network usage
w_net = widget.Net(format=" {down} ↓↑ {up}", use_bits=True, interface=["enp34s0"])
if HOST == "andlang":
    netgraph_iface = "enp34s0"
elif HOST == "bifrost":
    netgraph_iface = "wlp0s20f3"
w_netgraph = widget.NetGraph(
    interface=netgraph_iface, border_color="#444959", graph_color="#e69055", fill_color="#C45500"
)

# Audio level
w_vol = widget.Volume(
    fmt="墳 {}",
    update_interval=0.2,
    # get_volume_command="pulsemixer --get-volume | awk '{print $1}'",
)
# Time
w_clock = widget.Clock(format="%Y-%m-%d %a %H:%M")
# Systray
w_tray = widget.Systray(padding=0)

# andlang specific
if HOST == "andlang":
    # mpd
    w_mpd = widget.Mpd2(
        status_format=" {artist} - {title} {play_status}",
        play_states={"pause": "", "play": "▶", "stop": "■"},
    )
    # Temperature
    w_cpu_temp = widget.ThermalZone(
        format="CPU: {temp}°C", zone="/sys/class/hwmon/hwmon1/temp1_input", high=60, crit=70
    )
    w_gpu_temp = widget.ThermalZone(
        format="GPU: {temp}°C", zone="/sys/class/hwmon/hwmon2/temp1_input", high=60, crit=70
    )

# bifrost specific
if HOST == "bifrost":
    # Battery
    w_batt = widget.Battery(format="{char} {percent:2.0%} {hour:d}:{min:02d}h")
    w_batt_icon = widget.BatteryIcon()
    # Backlight
    w_backlight = widget.Backlight(
        brightness_file="/sys/class/backlight/intel_backlight/brightness",
        max_brightness_file="/sys/class/backlight/intel_backlight/max_brightness",
        fmt=" {}",
    )
    w_temp = widget.ThermalZone(high=60, crit=70)


if HOST == "andlang":
    screens = [
        Screen(
            top=bar.Bar(
                widgets=[
                    # widget.GroupBox(
                    #     padding=1,
                    #     font=MYFONT,
                    #     disable_drag=True,
                    #     highlight_method="text",
                    #     highlight_color="#e69055",
                    #     active="#1f5582",
                    #     this_current_screen_border="#e69055",
                    #     this_screen_border="#e69055",
                    #     other_screen_border="#7bc275",
                    #     other_current_screen_border="#7bc275",
                    # ),
                    w_f_groupbox(),
                    w_sep,
                    w_layout,
                    w_sep,
                    widget.WindowName(),
                    w_sep,
                    w_mpd,
                    w_sep,
                    w_net,
                    w_netgraph,
                    w_sep,
                    w_cpu_temp,
                    w_gpu_temp,
                    w_sep,
                    w_vol,
                    w_sep,
                    w_clock,
                    w_sep,
                    w_tray,
                ],
                size=24,
                background="#242730",
            )
        ),
        Screen(
            top=bar.Bar(
                widgets=[
                    # widget.GroupBox(
                    #     padding=1,
                    #     font=MYFONT,
                    #     disable_drag=True,
                    #     highlight_method="text",
                    #     highlight_color="#e69055",
                    #     active="#1f5582",
                    #     this_current_screen_border="#e69055",
                    #     this_screen_border="#e69055",
                    #     other_screen_border="#7bc275",
                    #     other_current_screen_border="#7bc275",
                    # ),
                    w_f_groupbox(),
                    w_sep,
                    w_layout,
                    w_sep,
                    widget.WindowName(),
                    widget.Spacer(),
                    w_sep,
                    w_mpd,
                    w_sep,
                    w_net,
                    w_netgraph,
                    w_sep,
                    w_cpu_temp,
                    w_gpu_temp,
                    w_sep,
                    w_vol,
                    w_sep,
                    w_clock,
                ],
                size=24,
                background="#242730",
            )
        ),
    ]
if HOST == "bifrost":
    screens = [
        Screen(
            top=bar.Bar(
                widgets=[
                    w_f_groupbox(),
                    w_sep,
                    w_layout,
                    w_win_title,
                    w_sep,
                    w_net,
                    w_netgraph,
                    w_sep,
                    w_temp,
                    w_sep,
                    w_batt_icon,
                    w_batt,
                    w_sep,
                    w_backlight,
                    w_sep,
                    w_vol,
                    w_sep,
                    w_clock,
                    w_sep,
                    w_tray,
                ],
                size=24,
                background="#242730",
            )
        )
    ]

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
