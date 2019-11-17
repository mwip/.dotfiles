import subprocess
import re


def convert_time(s):
    if "hours" in s:
        mins = int(s.split(".")[1].split(" ")[0]) / 10 * 60
        return "{}:{:02d}".format(s.split(".")[0], int(mins))
    elif "minutes" in s:
        return "0:" + s.split(".")[0]
    else:
        return s


def battery_status():

    cmd = ['/usr/bin/upower', '-i',
           '/org/freedesktop/UPower/devices/battery_BAT0']
    string = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
    
    state = re.search("state: *(.+?)\n", string)
    time_to_empty = re.search("time to empty: *(.+?)\n", string)
    time_to_full = re.search("time to full: *(.+?)\n", string)
    percentage = re.search("percentage: *(.+?)\n", string)

    if (state.group(1) == "charging"):
        return " ﮣ " + percentage.group(1) + convert_time(time_to_full.group(1))
        
    if (state.group(1) == "discharging"):
        return "  " + percentage.group(1) + convert_time(time_to_empty.group(1))
