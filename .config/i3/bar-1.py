#!/usr/bin/env python

from i3pystatus import Status

# base16-rcn colors
normal = "#B8B8B8"
black = "#181818"
red = "#AB4642"
green = "#A1B56C"
yellow = "#F7CA88"
blue = "#7CAFC2"
magenta = "#BA8BAF"
cyan = "#86C1B9"
white = "#D8D8D8"
lblack = "#585858"
lwhite = "#F8F8F8"
gray = "#383838"
lbrown = "#DC9656"
brown = "#A16946"

# helpers {{{
def span(color,icon):
    return("<span color=\"" + color + "\">" + icon + "</span>")
# }}}

status = Status(standalone=True)

# mixer level {{{
# Note: the alsa module requires the alsaaudio python module
# status.register("alsa",
    # hints = {"markup": "pango"},
    # format = span(lbrown,"") + " {volume:3.0f}%",
    # color = normal,
# )
# }}}

# disk usage system {{{
status.register("disk",
    path = "/",
    hints = {"markup": "pango"},
    format = span(lbrown,'system') + " {avail}G",
    # format = span(lbrown,'/') + " {used} / {total}G [{avail}G]",
)
# }}}

# disk usage music {{{
status.register("disk",
    path = "/mnt/music",
    hints = {"markup": "pango"},
    format = span(lbrown,'music') + " {avail}G",
    # format = span(lbrown,'music') + " {used} / {total}G [{avail}G]",
)
# }}}

# disk usage sdb3 {{{
status.register("disk",
    path = "/mnt/sdb3",
    hints = {"markup": "pango"},
    format = span(lbrown,'sdb3') + " {avail}G",
    # format = span(lbrown,'sdb3') + " {used} / {total}G [{avail}G]",
)
# }}}

# mpd status {{{
status.register("mpd",
    format = "{status}  {artist} " + span(magenta,'-') + " {title}[ " + span(magenta,'::') + " {album}]",
    hints = {"markup": "pango"},
    max_field_len = 150,
    max_len = 200,
    color = normal,
    on_leftclick = "switch_playpause",
    on_rightclick = "",
    on_upscroll = "",
    on_downscroll = "",
    status = {
        "pause": span(yellow,''),
        "play": span(green,''),
        "stop": span(red,''),
    },
)
# }}}

status.run()

# vim: ts=4
