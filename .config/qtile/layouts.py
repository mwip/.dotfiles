from libqtile import layout

class Layouts(object):
    def init_layouts(self, my_gaps):
        return [
            layout.MonadTall(
	        border_width = 2, 
	        single_border_width = 2, 
                margin = my_gaps, 
	    ),
            layout.MonadWide(
                border_width = 2,
                single_border_width = 2,
                margin = my_gaps,
            ),
            layout.TreeTab(),
        ]
