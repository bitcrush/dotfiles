#!/usr/bin/env python

from i3pystatus import IntervalModule
from i3ipc import Connection


class WindowTitle(IntervalModule):
    """
    This class shows the title of the focused window.
    """
    settings = (
        ("color", "RGB hexadecimal code color specifier, default to #ffffff"),
    )
    color = "#ffffff"
    interval = 1

    def run(self):
        # Establish socket connection
        conn = Connection()

        # Get window tree and name of focused window
        tree = conn.get_tree()
        win_name = tree.find_focused().name

        self.output = {
            "full_text": win_name,
            "color": self.color,
            "urgent": False,
        }
