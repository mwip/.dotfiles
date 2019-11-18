# heavily influenced by
# https://github.com/qtile/qtile-examples/blob/82bb924d29c2669c13b157dd7d9c0d66b9389843/osimplex/functions.py
from libqtile.command import lazy
import get_brightness
import batterystatus
import subprocess, re

class Function(object):

    ##### DEFINING SOME WINDOW FUNCTIONS #####
    @staticmethod
    def window_to_prev_group():
        @lazy.function
        def __inner(qtile):
            if qtile.current_window is not None:
                i = qtile.groups.index(qtile.current_group)
                qtile.current_window.togroup(qtile.groups[i - 1].name)
        return __inner

    @staticmethod
    def window_to_next_group():
        @lazy.function
        def __inner(qtile):
            if qtile.current_window is not None:
                i = qtile.groups.index(qtile.current_group)
                qtile.current_window.togroup(qtile.groups[i + 1].name)
        return __inner

    # logout with dmenu check for security
    @staticmethod
    def exit_menu():
        @lazy.function
        def __inner(qtile):
            cmd = script_path + 'dmenu_exit.sh'
            os.system(cmd)
        return __inner

    @staticmethod
    def window_to_prev_group():
        @lazy.function
        def __inner(qtile):
            if qtile.current_window is not None:
                index = qtile.groups.index(qtile.current_group)
                if index > 0:
                    qtile.current_window.togroup(qtile.groups[index - 1].name)
                else:
                    qtile.current_window.togroup(qtile.groups[len(qtile.groups) - 2].name)
        return __inner

    @staticmethod
    def window_to_next_group():
        @lazy.function
        def __inner(qtile):
            if qtile.current_window is not None:
                index = qtile.groups.index(qtile.current_group)
                if index < len(qtile.groups) - 2:
                    qtile.current_window.togroup(qtile.groups[index + 1].name)
                else:
                    qtile.current_window.togroup(qtile.groups[0].name)
        return __inner

    @staticmethod
    def window_to_prev_screen():
        @lazy.function
        def __inner(qtile):
            if qtile.current_window is not None:
                index = qtile.screens.index(qtile.current_screen)
                if index > 0:
                    qtile.current_window.togroup(qtile.screens[index - 1].group.name)
                else:
                    qtile.current_window.togroup(qtile.screens[len(qtile.screens) - 1].group.name)
        return __inner

    @staticmethod
    def window_to_next_screen():
        @lazy.function
        def __inner(qtile):
            if qtile.current_window is not None:
                index = qtile.screens.index(qtile.current_screen)
                if index < len(qtile.screens) - 1:
                    qtile.current_window.togroup(qtile.screens[index + 1].group.name)
                else:
                    qtile.current_window.togroup(qtile.screens[0].group.name)
        return __inner


    @staticmethod
    def go_to_next_group():
        @lazy.function
        def __inner(qtile):
            index = qtile.groups.index(qtile.current_group)
            if index < len(qtile.groups) - 2:
                qtile.groups[index + 1].cmd_toscreen()
            else:
                qtile.groups[0].cmd_toscreen()
        return __inner


    @staticmethod
    def go_to_prev_group():
        @lazy.function
        def __inner(qtile):
            index = qtile.groups.index(qtile.current_group)
            if index > 0:
                qtile.groups[index - 1].cmd_toscreen()
            else:
                qtile.groups[len(qtile.groups) - 2].cmd_toscreen()
        return __inner

    @staticmethod
    def poll_battery():
        return batterystatus.battery_status()

    @staticmethod
    def poll_brightness():
        return get_brightness.get_brightness()

    @staticmethod
    def poll_volume():
        vol = subprocess.run(['/usr/bin/pamixer','--get-volume-human'], stdout=subprocess.PIPE).stdout.decode('utf-8')
        return "墳 " + re.sub('\n', '', vol)


