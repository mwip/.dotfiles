from libqtile.config import Group, Key
from libqtile.command import lazy

class Groups(object):
    
    def init_groups(self):
        
        return [
            Group('1', label = '1:'),#, matches = Match(title=["Firefox"])),
            Group('2', label = '2:'),#, matches = Match(title=["emacs"])),
            Group('3', label = '3:'),
            Group('4', label = '4:'),
            Group('5', label = '5:'),
            Group('6', label = '6:ﱘ'),
            Group('7', label = '7:'),
            Group('8', label = '8:'),
            Group('9', label = '9:'),
            Group('0', label = '0:')
        ]

    @staticmethod
    def add_group_key_bindings(groups, keys, mod):
        for i in groups:
            # mod + letter of group = switch to group
            keys.append(Key([mod], i.name, lazy.group[i.name].toscreen()))
            # mod + shift + letter of group = switch to & move focused window to group
            keys.append(Key([mod, 'shift'], i.name, lazy.window.togroup(i.name)))
        return keys
