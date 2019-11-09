#!/usr/bin/env python3
# This script will logout from qtile
# found here:
# https://github.com/qtile/qtile-examples/blob/master/mort65/bin/qtile-logoff

from libqtile.command import Client
import getpass
import subprocess

try:
    client = Client()
    client.shutdown()
except:
    subprocess.Popen(["loginctl", "terminate-user", getpass.getuser()])
