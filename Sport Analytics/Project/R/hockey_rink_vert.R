# Create the hockey ring
# We will store in a list all the attributes needed to be plotted in plotly
# The list will be used in the Layout function for "shapes"
rink_shapes <- list()
library(rlist)  # For the function list.append()

# ------------------------------------------------------------------------------
# OUTER LINES
# ------------------------------------------------------------------------------

# Upper line of the rectangle

rink_shapes <- list.append(rink_shapes, list(
  type = 'rect',
  xref = 'x',
  yref = 'y',
  x0 = "-42.5",#'-250',
  y0 = '0',
  x1 = "42.5",#'250',
  y1 = "89",#'516.2',
  line = list(
    width = 1.5,
    color='rgba(0, 0, 0 0.5)'
  )
))

# Line to support the arcs

rink_shapes <- list.append(rink_shapes, list(
  type = 'line',
  xref = 'x',
  yref = 'y',
  x0 = "34", #'200',
  y0 = "100",#'580',
  x1 = "-34", #'-200',
  y1 = "100",#'580',
  line = list(
    width=1.5,
    color='rgba(0, 0, 0 0.5)'
  )
))

# Arcs themselves (upper arc)

rink_shapes <- list.append(rink_shapes, list(
  type = 'path',
  xref = 'x',
  yref = 'y',
  path = 'M 34 100 C 36.89 98.96552, 41.99 91.72414, 42.5 89',
  #path = 'M 200 580 C 217 574, 247 532, 250 516.2',
  line = list(
    width=1.5,
    color='rgba(0, 0, 0 0.5)'
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type = 'path',
  xref = 'x',
  yref = 'y',
  path = 'M -34 100 C -36.89 98.96552, -41.99 91.72414, -42.5 89',
  #path = 'M 200 580 C 217 574, 247 532, 250 516.2',
  line = list(
    width=1.5,
    color='rgba(0, 0, 0 0.5)'
  )
))

# ------------------------------------------------------------------------------
# RED LINES
# ------------------------------------------------------------------------------

# Red line in the center of the rink along the width

rink_shapes <- list.append(rink_shapes, list(
  type='rect',
  xref='x',
  yref='y',
  x0="-42.5",#'-250',
  y0='0.5',
  x1="42.5",#'250',
  y1='-0.5',
  line=list(
    width=1,
    color='rgba(255, 0, 0, 0.5)'
  ),
  fillcolor='rgba(255, 0, 0, 0.5)'
))

# This line is 11 ft away from the end of the rink and red in color

rink_shapes <- list.append(rink_shapes, list(
  type='rect',
  xref='x',
  yref='y',
  x0="-42.5",#'-250',
  y0="89.08333",#'516.2',
  x1="42.5",#'250',
  y1="88.91667",#'516.2',
  line=list(
    width=1,
    color='rgba(255, 0, 0, 0.5)'
  ),
  fillcolor='rgba(255, 0, 0, 0.5)'
))

# ------------------------------------------------------------------------------
# BLUE LINE
# ------------------------------------------------------------------------------

rink_shapes <- list.append(rink_shapes, list(
  type='rect',
  xref='x',
  yref='y',
  x0="42.5",#'250',
  y0="26",#'150.8',
  x1="-42.5",#'-250',
  y1="25",#'-145',
  line=list(
    color='rgba(0, 0, 255, 0.5)',
    width=1
  ),
  fillcolor='rgba(0, 0, 255, 0.5)'
))

# ------------------------------------------------------------------------------
# FACE-OFF SPOTS AND CIRCLES
# ------------------------------------------------------------------------------

# Circular blue spot for the center

rink_shapes <- list.append(rink_shapes, list(
  type='circle',
  xref='x',
  yref='y',
  x0="0.3",#'2.94', ---> 0.15
  y0="0.9",#'2.8', --> 0.476
  x1="-0.3",#'-2.94', ---> 0.15
  y1="-0.9",#'-2.8', --> -0.476
  line=list(
    color='rgba(0, 0, 255, 0.5)',
    width=1
  ),
  fillcolor='rgba(0, 0, 255, 0.5)'
))

# Two red spots for the nuetral zone

rink_shapes <- list.append(rink_shapes, list(
  type='circle',
  xref='x',
  yref='y',
  x0="22.515",#'135.5',
  y0="21",#'121.8',
  x1="21.515",#'123.5',
  y1="19",#'110.2',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1
  ),
  fillcolor='rgba(255, 0, 0, 0.5)'
))

rink_shapes <- list.append(rink_shapes, list(
  type='circle',
  xref='x',
  yref='y',
  x0="-22.515",#'135.5',
  y0="21",#'121.8',
  x1="-21.515",#'123.5',
  y1="19",#'110.2',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1
  ),
  fillcolor='rgba(255, 0, 0, 0.5)'
))

# Red circles

rink_shapes <- list.append(rink_shapes, list(
  type='circle',
  xref='x',
  yref='y',
  x0="36.992",#'217.6',
  y0="84",#'487.2',
  x1="7.004",#'41.2',
  y1="54",#'313.2',
  line=list(
    width=1.5,
    color='rgba(255, 0, 0, 0.5)'
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='circle',
  xref='x',
  yref='y',
  x0="-36.992",#'217.6',
  y0="84",#'487.2',
  x1="-7.004",#'41.2',
  y1="54",#'313.2',
  line=list(
    width=1.5,
    color='rgba(255, 0, 0, 0.5)'
  )
))

# ------------------------------------------------------------------------------
# FACE-OFF LINES
# ------------------------------------------------------------------------------

# 69 is the center

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="39.1",#'230',
  y0="71.8",#'416.4',
  x1="36.728",#'217.8',
  y1="71.8",#'416.4',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  ),
  layer = 'below'
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="39.1",#'230',
  y0="66.2",#'384',
  x1="36.728",#'217.8',
  y1="66.2",#'384',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="-39.1",#'230',
  y0="71.8",#'416.4',
  x1="-36.728",#'217.8',
  y1="71.8",#'416.4',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="-39.1",#'230',
  y0="66.2",#'384',
  x1="-36.728",#'217.8',
  y1="66.2",#'384',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

# ------------------------------------------------------------------------------
# FACE-OFF CONFIGURATION LINES
# ------------------------------------------------------------------------------

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="24",#'141.17',
  y0="73",#'423.4',
  x1="24",#'141.17',
  y1="70",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="24",#'141.17',
  y0="68",#'423.4',
  x1="24",#'141.17',
  y1="65",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="20",#'117.62',
  y0="73",#'423.4',
  x1="20",#'117.62',
  y1="70",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="20",#'117.62',
  y0="68",#'423.4',
  x1="20",#'117.62',
  y1="65",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="26",#'153',
  y0="70",#'406',
  x1="24",#'105.8',
  y1="70",#'406',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="20",#'153',
  y0="70",#'406',
  x1="18",#'105.8',
  y1="70",#'406',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="26",#'153',
  y0="68",#'394.4',
  x1="24",#'105.8',
  y1="68",#'394.4',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="20",#'153',
  y0="68",#'394.4',
  x1="18",#'105.8',
  y1="68",#'394.4',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="-24",#'141.17',
  y0="73",#'423.4',
  x1="-24",#'141.17',
  y1="70",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="-24",#'141.17',
  y0="68",#'423.4',
  x1="-24",#'141.17',
  y1="65",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="-20",#'117.62',
  y0="73",#'423.4',
  x1="-20",#'117.62',
  y1="70",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="-20",#'117.62',
  y0="68",#'423.4',
  x1="-20",#'117.62',
  y1="65",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="-26",#'153',
  y0="70",#'406',
  x1="-24",#'105.8',
  y1="70",#'406',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="-20",#'153',
  y0="70",#'406',
  x1="-18",#'105.8',
  y1="70",#'406',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="-26",#'153',
  y0="68",#'394.4',
  x1="-24",#'105.8',
  y1="68",#'394.4',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="-20",#'153',
  y0="68",#'394.4',
  x1="-18",#'105.8',
  y1="68",#'394.4',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

# Red dots

rink_shapes <- list.append(rink_shapes, list(
  type='circle',
  xref='x',
  yref='y',
  x0="22.515",#'135.5',
  y0="70",#'121.8',
  x1="21.515",#'123.5',
  y1="68",#'110.2',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1
  ),
  fillcolor='rgba(255, 0, 0, 0.5)'
))

rink_shapes <- list.append(rink_shapes, list(
  type='circle',
  xref='x',
  yref='y',
  x0="-22.515",#'135.5',
  y0="70",#'121.8',
  x1="-21.515",#'123.5',
  y1="68",#'110.2',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1
  ),
  fillcolor='rgba(255, 0, 0, 0.5)'
))

# ------------------------------------------------------------------------------
# GOAL CREASE
# ------------------------------------------------------------------------------

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="10.999",#'64.7',
  y0="89",#'516.2',
  x1="13.991",#'82.3',
  y1="100",#'580',
  line=list(
    width=1.5,
    color='rgba(0, 0, 0 .8)'
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="3.995",#'23.5',
  y0="89",#'516.2',
  x1="3.995",#'23.5',
  y1="85",#'493',
  line=list(
    width=1.5,
    color='rgba(0, 0, 0 .8)'
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="-10.999",#'64.7',
  y0="89",#'516.2',
  x1="-13.991",#'82.3',
  y1="100",#'580',
  line=list(
    width=1.5,
    color='rgba(0, 0, 0 .8)'
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  x0="-3.995",#'23.5',
  y0="89",#'516.2',
  x1="-3.995",#'23.5',
  y1="85",#'493',
  line=list(
    width=1.5,
    color='rgba(0, 0, 0 .8)'
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='path',
  xref='x',
  yref='y',
  path='M 3.995 85 C 3.4 82.75862, -3.4 82.75862, -3.995 85',
  #path='M 23.5 493 C 20 480, -20 480, -23.5 493',
  line=list(
    width=1.5,
    color='rgba(0, 0, 0 .8)'
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='path',
  xref='x',
  yref='y',
  path='M 2.992 89 C 2.55 91.37931, -2.55 91.37931, -2.992 89',
  #path='M 17.6 516.2 C 15 530, -15 530, -17.6 516.2',
  line=list(
    width=1.5,
    color='rgba(0, 0, 0 .8)'
  )
))

# ------------------------------------------------------------------------------
# REFEREE CREASE
# ------------------------------------------------------------------------------

rink_shapes <- list.append(rink_shapes, list(
  type='path',
  xref='x',
  yref='y',
  path='M ',
  line=list(
    width=1.5,
    color='rgba(255, 0, 0, 0.5)'
  )
))