# heavily influenced by
#https://github.com/qtile/qtile-examples/blob/master/osimplex/rules.py

# import re

from libqtile.config import Match, Rule

class Rules(object):
	def init_rules(self):
		return [
                    # Floating names
		    Rule(
			Match(title = [
                            # "mpvfloat",
			    # "Create new database",
                            "Unlock Database - KeePassXC"
			    # "Sozi"
			]),
			float = True
		    ), 
		    # Floating types
		    Rule(
		    	Match(wm_type = [
		    		"confirm",
		    		"download",
		    		"notification",
		    		"toolbar",
		    		"splash",
		    		"dialog",
		    		"error",
		    		"file_progress",
		    		"confirmreset",
		    		"makebranch",
		    		"maketag",
		    		"branchdialog",
		    		"pinentry",
		    		"sshaskpass"
		    	]),
		    	float = True
		    ),
		    # # Floating classes
		    # Rule(
		    # 	Match(wm_class = [
		    # 		"Xfce4-taskmanager",
		    # 		"Gparted",
		    # 		"Gsmartcontrol",
		    # 		"Timeshift-gtk",
		    # 		"Gufw.py",
		    # 		"Bleachbit",
		    # 		"Nitrogen",
		    # 		"Lightdm-gtk-greeter-settings",
		    # 		"Nm-connection-editor",
		    # 		"Lxappearance",
		    # 		"Pavucontrol",
		    # 		"Volumeicon",
		    # 		"hp-toolbox",
		    # 		"System-config-printer.py",
		    # 		"Arandr",
		    # 		"qt5ct",
		    # 		"Catfish",
		    # 		# "Nemo",
		    # 		"Thunar",
		    # 		"Meld",
		    # 		"Engrampa",
		    # 		"File-roller",
		    # 		"Simple-scan",
		    # 		"Mousepad",
		    # 		"Gnucash",
		    # 		"Gcolor3",
		    # 		"vlc",
		    # 		"Gnome-multi-writer",
		    # 		"balena-etcher-electron",
		    # 		"Virt-manager",
		    # 		re.compile("VirtualBox")
		    # 	]),
		    # 	float = True,
		    # 	break_on_match = False
		    # ),
		]
