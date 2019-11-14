#!/usr/bin/python
import subprocess
import re

def get_brightness():
    cmd = ['/usr/bin/xbacklight', '-get']
    string = subprocess.run(cmd, stdout = subprocess.PIPE).stdout.decode('utf-8')
    brightness = int(round(float(string),0))
    return " {}%".format(brightness)# "ﯧ {}%".format(brightness)

# print(get_brightness())
