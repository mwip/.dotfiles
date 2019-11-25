from libqtile import widget
from functions import Function

class Widgets(object):

    def __init__(self, hostname, primaryMonitor = True):
        self.hostname = hostname
        self.primaryMonitor = primaryMonitor

    def init_widgets(self):
        allhosts = ["bifrost", "walhall"]
        hosts_and_widgets = [
            [
                allhosts,
                "allMonitors",
                widget.CurrentScreen(
                    active_text = "",
                    active_color = "FF0000",
                    inactive_text = "",
                    inactive_color = "222222",
                    font = "Ubuntu Mono Nerd Font",
                    fontsize = 16,
                )
            ],
            [
                allhosts, 
                "allMonitors",
                widget.Sep(
                    linewidth = 1,
                    padding = 5),
            ],
            [
                allhosts, 
		"allMonitors",
                widget.GroupBox(
                    highlight_method = 'line',
                    this_screen_border = '805300',
                    this_current_screen_border = '805300',
                    active = 'e69500',
                    inactive = '555555',
                    font = "Ubuntu Mono Nerd Font",
                    fontsize = 16,
                ),
            ],
            [
                allhosts,
                "allMonitors",
                widget.Sep(
                    linewidth = 1,
                    padding = 5),
            ],
            [
                allhosts,
                "allMonitors",
                widget.TaskList(
                    highlight_method = "block",
                    fontsize = 12,
                    border = '805300',
                    font = "Ubuntu Mono Nerd Font"
            ),
            ],
            [
                allhosts,
                "allMonitors",
                widget.Sep(
                    linewidth = 1,
                    padding = 5),
            ],
            [
                allhosts,
                "allMonitors",
                widget.TextBox(""),
            ],
            [
                allhosts,
                "allMonitors",
                widget.CPUGraph(
                    fill_color = "e69500.3",
                    graph_color = 'e69500',
                    border_color = '805300',
                    font = "Ubuntu Mono Nerd Font",
                    fontsize = 16,
                ),
            ],
            [
                allhosts,
                "allMonitors",
                widget.TextBox(""),
            ],
            [
                allhosts,
                "allMonitors",
                widget.MemoryGraph(
                    fill_color = "e69500.3",
                    graph_color = 'e69500',
                    border_color = '805300',
                    font = "Ubuntu Mono Nerd Font",
                    fontsize = 16,
                ),
            ],
            # [
            #     allhosts,
            #     # widget.TextBox(""),
            # ],
            # [
            #     allhosts,
            #     # widget.NetGraph(
            #     #     fill_color = "e69500.3",
            #     #     graph_color = 'e69500',
            #     #     border_color = '805300'
            #     # ),
            # ],
            [
                allhosts,
                "allMonitors",
                widget.Sep(
                    linewidth = 1,
                    padding = 5),
            ],
            [
                allhosts,
                "allMonitors",
                widget.CurrentLayout(
                    font = "Ubuntu Mono Nerd Font",
                    fontsize = 16,
                ),
            ],
            # [
            #     allhosts,
            #     # widget.CurrentLayoutIcon(
                # custom_icon_paths = '/home/loki/.icons/layout-icons/'
                # ),
        # ],
            [
                allhosts,
                "allMonitors",
                widget.Sep(
                    padding = 5,
                    linewidth = 1,
                ),
            ],
            [
                allhosts,
                "primary",
                widget.Systray(
                    padding = 5
                ),
            ],
            [
                allhosts,
                "primary",
                widget.Sep(
                    padding = 5,
                    linewidth = 1,
                ),
            ],
            # [
            #     allhosts,
            #     #widget.BatteryIcon(
            #     #    fontsize = 0,
            #     #theme_path = '/home/loki/.icons/',
            #     #    update_interval = 5
            #     #),
            # ],
            [
                ["bifrost"],
                "allMonitors",
                widget.GenPollText(
                    func = Function.poll_battery,
                    update_interval = 5,
                    font = "Ubuntu Mono Nerd Font",
                    fontsize = 16,
                ),
            ],
            [
                ["bifrost"],
                "allMonitors",
                widget.Sep(
                    linewidth = 1,
                    padding = 5),
            ],
            [
                allhosts,
                "allMonitors",
                widget.GenPollText(
                    func = Function.poll_volume,
                    update_interval = 5,
                    font = "Ubuntu Mono Nerd Font",
                    fontsize = 16,
            ),
            ],
            [
                allhosts,
                "allMonitors",
                widget.Sep(
                    linewidth = 1,
                    padding = 5),
            ],
            [
                ["bifrost"],
                "allMonitors",
                widget.GenPollText(
                    func = Function.poll_brightness,
                    update_interval = 5,
                    font = "Ubuntu Mono Nerd Font",
                    fontsize = 16,
                ),
            ],
            [
                ["bifrost"],
                "allMonitors",
                widget.Sep(
                    linewidth = 1,
                    padding = 5),
            ],
            [
                allhosts,
                "allMonitors",
                widget.Clock(
                    format = "%Y-%m-%d - %H:%M:%S",
                    font = "Ubuntu Mono Nerd Font",
                    fontsize = 16,
                )
            ]
        ]

        widgets = []
        for i in hosts_and_widgets:
            if self.hostname in i[0]:
                if self.primaryMonitor:
                    widgets.append(i[2])
                elif i[1] == "allMonitors":
                    widgets.append(i[2])
        
        return widgets
    
