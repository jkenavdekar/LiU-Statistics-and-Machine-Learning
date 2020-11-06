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
  y0 = "-42.5",#'-250',
  x0 = '0',
  y1 = "42.5",#'250',
  x1 = "89",#'516.2',
  line = list(
    width = 1.5,
    color='rgba(0, 0, 0, 0.5)'
  )
))

# Line to support the arcs

rink_shapes <- list.append(rink_shapes, list(
  type = 'line',
  xref = 'x',
  yref = 'y',
  y0 = "34", #'200',
  x0 = "100",#'580',
  y1 = "-34", #'-200',
  x1 = "100",#'580',
  line = list(
    width=1.5,
    color='rgba(0, 0, 0, 0.5)'
  )
))

# Arcs themselves (upper arc)

rink_shapes <- list.append(rink_shapes, list(
  type = 'path',
  xref = 'x',
  yref = 'y',
  path = 'M 100 34 C 98.96552 36.89, 91.72414 41.99, 89 42.5',
  #path = 'M 200 580 C 217 574, 247 532, 250 516.2',
  line = list(
    width=1.5,
    color='rgba(0, 0, 0, 0.5)'
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type = 'path',
  xref = 'x',
  yref = 'y',
  path = 'M 100 -34 C 98.96552 -36.89, 91.72414 -41.99, 89 -42.5',
  #path = 'M 200 580 C 217 574, 247 532, 250 516.2',
  line = list(
    width=1.5,
    color='rgba(0, 0, 0, 0.5)'
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
  y0="-42.5",#'-250',
  x0='0.5',
  y1="42.5",#'250',
  x1='-0.5',
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
  y0="-42.5",#'-250',
  x0="89.08333",#'516.2',
  y1="42.5",#'250',
  x1="88.91667",#'516.2',
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
  y0="42.5",#'250',
  x0="26",#'150.8',
  y1="-42.5",#'-250',
  x1="25",#'-145',
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
  y0="0.3",#'2.94', ---> 0.15
  x0="0.9",#'2.8', --> 0.476
  y1="-0.3",#'-2.94', ---> 0.15
  x1="-0.9",#'-2.8', --> -0.476
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
  y0="22.515",#'135.5',
  x0="21",#'121.8',
  y1="21.515",#'123.5',
  x1="19",#'110.2',
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
  y0="-22.515",#'135.5',
  x0="21",#'121.8',
  y1="-21.515",#'123.5',
  x1="19",#'110.2',
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
  y0="36.992",#'217.6',
  x0="84",#'487.2',
  y1="7.004",#'41.2',
  x1="54",#'313.2',
  line=list(
    width=1.5,
    color='rgba(255, 0, 0, 0.5)'
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='circle',
  xref='x',
  yref='y',
  y0="-36.992",#'217.6',
  x0="84",#'487.2',
  y1="-7.004",#'41.2',
  x1="54",#'313.2',
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
  y0="39.1",#'230',
  x0="71.8",#'416.4',
  y1="36.728",#'217.8',
  x1="71.8",#'416.4',
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
  y0="39.1",#'230',
  x0="66.2",#'384',
  y1="36.728",#'217.8',
  x1="66.2",#'384',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="-39.1",#'230',
  x0="71.8",#'416.4',
  y1="-36.728",#'217.8',
  x1="71.8",#'416.4',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="-39.1",#'230',
  x0="66.2",#'384',
  y1="-36.728",#'217.8',
  x1="66.2",#'384',
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
  y0="24",#'141.17',
  x0="73",#'423.4',
  y1="24",#'141.17',
  x1="70",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="24",#'141.17',
  x0="68",#'423.4',
  y1="24",#'141.17',
  x1="65",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="20",#'117.62',
  x0="73",#'423.4',
  y1="20",#'117.62',
  x1="70",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="20",#'117.62',
  x0="68",#'423.4',
  y1="20",#'117.62',
  x1="65",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="26",#'153',
  x0="70",#'406',
  y1="24",#'105.8',
  x1="70",#'406',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="20",#'153',
  x0="70",#'406',
  y1="18",#'105.8',
  x1="70",#'406',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="26",#'153',
  x0="68",#'394.4',
  y1="24",#'105.8',
  x1="68",#'394.4',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="20",#'153',
  x0="68",#'394.4',
  y1="18",#'105.8',
  x1="68",#'394.4',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="-24",#'141.17',
  x0="73",#'423.4',
  y1="-24",#'141.17',
  x1="70",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="-24",#'141.17',
  x0="68",#'423.4',
  y1="-24",#'141.17',
  x1="65",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="-20",#'117.62',
  x0="73",#'423.4',
  y1="-20",#'117.62',
  x1="70",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="-20",#'117.62',
  x0="68",#'423.4',
  y1="-20",#'117.62',
  x1="65",#'377',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="-26",#'153',
  x0="70",#'406',
  y1="-24",#'105.8',
  x1="70",#'406',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="-20",#'153',
  x0="70",#'406',
  y1="-18",#'105.8',
  x1="70",#'406',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="-26",#'153',
  x0="68",#'394.4',
  y1="-24",#'105.8',
  x1="68",#'394.4',
  line=list(
    color='rgba(255, 0, 0, 0.5)',
    width=1.5
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="-20",#'153',
  x0="68",#'394.4',
  y1="-18",#'105.8',
  x1="68",#'394.4',
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
  y0="22.515",#'135.5',
  x0="70",#'121.8',
  y1="21.515",#'123.5',
  x1="68",#'110.2',
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
  y0="-22.515",#'135.5',
  x0="70",#'121.8',
  y1="-21.515",#'123.5',
  x1="68",#'110.2',
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
  y0="10.999",#'64.7',
  x0="89",#'516.2',
  y1="13.991",#'82.3',
  x1="100",#'580',
  line=list(
    width=1.5,
    color='rgba(0, 0, 0, .5)'
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="3.995",#'23.5',
  x0="89",#'516.2',
  y1="3.995",#'23.5',
  x1="85",#'493',
  line=list(
    width=1.5,
    color='rgba(0, 0, 0, .5)'
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="-10.999",#'64.7',
  x0="89",#'516.2',
  y1="-13.991",#'82.3',
  x1="100",#'580',
  line=list(
    width=1.5,
    color='rgba(0, 0, 0, .5)'
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='line',
  xref='x',
  yref='y',
  y0="-3.995",#'23.5',
  x0="89",#'516.2',
  y1="-3.995",#'23.5',
  x1="85",#'493',
  line=list(
    width=1.5,
    color='rgba(0, 0, 0, .5)'
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='path',
  xref='x',
  yref='y',
  path='M 85 3.995 C 82.75862 3.4, 82.75862 -3.4, 85 -3.995',
  #path='M 23.5 493 C 20 480, -20 480, -23.5 493',
  line=list(
    width=1.5,
    color='rgba(0, 0, 0, .5)'
  )
))

rink_shapes <- list.append(rink_shapes, list(
  type='path',
  xref='x',
  yref='y',
  path='M 89 2.992 C 91.37931 2.55, 91.37931 -2.55, 89 -2.992',
  #path='M 17.6 516.2 C 15 530, -15 530, -17.6 516.2',
  line=list(
    width=1.5,
    color='rgba(0, 0, 0, .5)'
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