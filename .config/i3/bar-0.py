#!/usr/bin/env python

from i3pystatus import Status, window_title

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

# toggle between text and icon labels
# fontawesome = 0

# helpers {{{
def span(color,icon):
    return("<span color=\"" + color + "\">" + icon + "</span>")
# }}}

status = Status(standalone=True)

# date / clock {{{
# Displays clock like this: Tue 30 Jul 23:59
status.register("clock",
    hints = {"markup": "pango"},
    color = normal,
    format = span(magenta,"%a %-d %b") + " " + span(normal,"%H:%M"),
    # format = span(magenta,"") + "  %a %-d %b" + " " + span(magenta,"") + "  %H:%M",
)
# }}}

# memory usage {{{
status.register("mem",
    hints = {"markup": "pango"},
    format = span(lbrown,"Mem") + " " + "{percent_used_mem:4.1f}%",
    color = normal,
    warn_percentage = 70,
    warn_color = yellow,
    alert_percentage = 90,
    alert_color = red,
)
# }}}

# cpu freq {{{
status.register("cpu_freq",
    hints = {"markup": "pango"},
    format = span(blue,"GHz") + " " + "{avgg:>4}",
)
# }}}

# cpu usage {{{
status.register("cpu_usage",
    hints = {"markup": "pango", "separator": False, "separator_block_width": 6},
    format = span(blue,"CPU") + " " + "{usage:>2d}%",
)
# }}}

# remote ip {{{
status.register("file",
    hints = {"markup": "pango"},
    components = { "myip": ( str, "/tmp/myip" ) },
    format = span(green,"IP") + " " + "{myip:>15}",
    # format = span(green,"") + "  " + "{myip:>15}",
    color = normal,
)
#}}}

# network traffic {{{
# Note: the network module requires PyPI package netifaces
status.register("network",
    interface = "eth0",
    hints = {"markup": "pango"},
    start_color = normal,
    end_color = normal,
    color_up = normal,
    color_down = red,
    format_up = span(magenta,'TX') + " " + "{bytes_sent:>5d} KB/s",
    # format_up = span(magenta,'') + " " +  "{bytes_sent:>5} KB/s",
)

status.register("network",
    interface = "eth0",
    hints = {"markup": "pango"},
    start_color = normal,
    end_color = normal,
    color_up = normal,
    color_down = red,
    format_up = span(magenta,'RX') + " " + "{bytes_recv:>5d} KB/s",
    # format_up = span(magenta,'') + " " + "{bytes_recv:>15d} KB/s",
)
# }}}

# weather {{{
status.register("weather",
    hints = {"markup": "pango"},
    location_code="GMXX0017",
    units="metric",
    interval=300,
    format=span(yellow,"Tmp") + " " + "{current_temp:>5}" + " " + span(blue,"Hum") + " " + "{humidity:>3}%",
    # format=span(yellow,"") + "   " + "{current_temp:>2}" + " " + span(blue,"") + "   " + "{humidity:>3}%",
)
# }}}

# window title {{{
status.register("window_title",
    # hints = {"markup": "pango", "separator": False, "separator_block_width": 6},
    # format = span(blue,"CPU") + "{usage:2}%",
    color = magenta,
)
# }}}

status.run()

# vim: ts=4
