# Global ui --> Shinydashboard

library(shiny)
library(shinydashboard)
library(shinyBS)
library(shinyjs)
library(shinyWidgets)
library(plotly)

BIN_SLIDER_TAG <- "N. of shades"
PERIOD_TAG <- "Periods"
LAYERS <- "Shot outcome"
LAYERS_MANPOWER <- "Manpower differential"
TEAM_TAG <- "Team in possesion"
TYPE_TAG <- 'Type'
ZONE_TAG <- "Zone of the shots"
BLOCKED_TAG <- "Blocked shots"
DEFLECTED_TAG <- "Deflected shots"
SWITCH_TAG <- "Flip plot"
SWITCH_TAG_ACTION <- "Rotate"
ANGLES_TAG <- "Show / hide zone division"
ANGLES_TAG_ACTION <- "Zones"
RESET_TAG <- "Reset"



ADD_ANGLES <- function() {
  fluidPage(
    column(6,
           tags$label(ANGLES_TAG)),
    column(6,
           tipify(actionButton('add_angles', 
                               label = ANGLES_TAG_ACTION, 
                               icon = icon("draw-polygon")),
                  "Click to show the zone divisions", placement = "right"))
  )
}

# Number of shades slider
BIN_SLIDER <- function(min, max, value){
  tipify(
    fluidRow(
      column(3, 
             tags$label(BIN_SLIDER_TAG)
             ),
      column(9, 
             sliderInput("binNumber", 
                         label = NULL, 
                         min = min, 
                         max = max, 
                         value = value,
                         step = 1,
                         ticks = T)
            )
  ), "Adjust the number of colours", placement = "right")
}

# Succesful/unsuccessful shots
PERIOD <- function(choices, selected){
  tipify(checkboxGroupInput("period", label = PERIOD_TAG,
                            choices = choices,
                            selected = selected,
                            inline = T),
         "Period(s) to visualize the shots from", placement = "right")
}

TEAM_SELECT <- function(selected = 'Statisticians'){
  tipify(fluidRow(
    column(3, tags$label(TEAM_TAG)),
    column(9,					
           selectInput('team', label = NULL, 
                       choices = c(
                         'Linköping' = "Linköping Linköping HC",
                         'Opponent' = "Opponent"
                       ), 
                       selected = selected)
    )
  ), "Choose which team performed the shots", placement = "right")
}

TYPE_SELECT <- function(selected = 'continous'){
  tipify(fluidRow(
    column(3, tags$label(TYPE_TAG)),
    column(9,					
           pickerInput('type', label = NULL, 
                       choices = c(
                         'Continous' = "continous",
                         'Discrete' = "discrete",
                         'Extended' = "extended"
                       ), 
                       selected = selected,
                       options = list(
                         `actions-box` = TRUE, 
                         # size = 10,
                         `selected-text-format` = "count > 3"
                       ))
    )
  ), "Select typology of heatmap", placement = "right")
}

ZONE_SELECT <- function(choices, selected){
  tipify(fluidRow(
    column(6, tags$label(ZONE_TAG)),
    column(6,
           pickerInput('zone', label = NULL,
                       multiple = TRUE,
                       choices = c("Outside" = "outside", "Slot" = "slot"), 
                       selected = c("outside", "slot"),
                       options = list(
                         `actions-box` = TRUE, 
                         # size = 10,
                         `selected-text-format` = "count > 3"
                       ))
           )),
    "Choose from which area the shots were done", placement = "right")
}

BLOCKED_SELECT <- function(choices, selected){
  tipify(fluidRow(
    column(6, tags$label(BLOCKED_TAG)),
    column(6, pickerInput('blocked', label = NULL,
                          multiple = TRUE,
                          choices = c("Blocked" = "1", "Unblocked" = "0"), 
                          selected = c("0", "1"), 
                          options = list(
                            `actions-box` = TRUE, 
                            # size = 10,
                            `selected-text-format` = "count > 3"
                          ))
           )),
    "Filter the blocked shots", placement = "right")
}

DEFLECTED_SELECT <- function(choices, selected){
  tipify(fluidRow(
    column(6, tags$label(DEFLECTED_TAG)),
    column(6, pickerInput('deflected', label = NULL, 
                     multiple = TRUE,
                     choices = c("Deflected" = "1", "Straight" = "0"), 
                     selected = c("1", "0"), 
                     options = list(
                       `actions-box` = TRUE, 
                       # size = 10,
                       `selected-text-format` = "count > 3"
                     ))
           )),
    "Filter the deflected shots", placement = "right")
}

LAYERS_SELECT <- function(choices, selected){
  tipify(fluidRow(
    column(6, tags$label(LAYERS)),
    column(6, pickerInput('layers', label = NULL,
                          multiple = TRUE,
                          choices = choices, 
                          selected = selected,
                          options = list(
                            `actions-box` = TRUE, 
                            # size = 10,
                            `selected-text-format` = "count > 3"
                          ))
           )),
    "Add/delate a type of shots", placement = "right")
}

LAYERS_SELECT_MANPOWER <- function(choices, selected){
  tipify(fluidRow(
    column(6, tags$label(LAYERS_MANPOWER)),
    column(6, pickerInput('layers_manpower', label = NULL,
                          multiple = TRUE,
                          choices = choices, 
                          selected = selected,
                          options = list(
                            `actions-box` = TRUE, 
                            # size = 10,
                            `selected-text-format` = "count > 3"
                          ))
           )),
    "Select the manpower differential", placement = "right")
}

SWITCH_COORD <- function() {
  fluidRow(
    column(6,
           tags$label(SWITCH_TAG)),
    column(6,
           tipify(actionButton('switch', 
                               label = SWITCH_TAG_ACTION, 
                               icon = icon("redo-alt")),
                  "Click to flip the plot", placement = "right"))
  )
}

RESET <- function() {
  tipify(actionBttn('reset', label = RESET_TAG,
                    style = "unite",
                    icon = icon("minus-circle"),
                    color = 'danger',
                    size = 'sm'
                    # status = "danger"
                    #width = "300px",
                    #   tooltip = tooltipOptions(
                    #      title = 'RESET')
  ),
  "Click to reset to blank", placement = "right"
  
  )
}

#PLAYER_WHO_SHOT <- function(choice, selected){
#  tipify(pickerInput('player_shot', label = PLAYER_WHO_SHOT_TAG, 
#                     multiple = TRUE,
#                     choices = choice,
#                     selected = selected,
#                     options = list(
#                       `actions-box` = TRUE, 
#                       size = 10,
#                       `selected-text-format` = "count > 3"
#                     )), 
#         "Select the player(s) who made the shots", placement = "left")
#}

# Colours of the team:
# Red: #ff151f
# Blue: #003690
# White: #ffffff
# Light blue (lion's hair): #b4c9e8

# Variations of the colours:
# Darkred: #d80f17

col_text = "#fff"
# Sidebar: darkred background, white text
col_sidebar <- "#d80f17"
# Main body: red background, white text
col_body_main <- "#b30b12"
# Boxes: blue background, white text
# NOTE: no distinction between header, body and footer of the box.
col_box_plots <- "#003690"

# To make it work see here: https://stackoverflow.com/questions/38011285/image-not-showing-in-shiny-app-r
# title <- tags$a(href='https://www.lhc.eu/',
#                 tags$img(src = "logo_LHC.png", height = "50", width = "50"),
#                 "LHC visualization tool", target="_blank")
title <- "LHC visualization tool"
header <- dashboardHeader()
anchor <- tags$a(href='http://www.example.com',
                 tags$img(src='logo_LHC.png', height='45', width='45'),
                 HTML('<h4 style="color:white">LHC Heatmapper</h4>'))
# anchor <- tags$li(tags$img(src='logo_LHC.png', height='60', width='50'),
#                   'LHC Heatmapper')

header$children[[2]]$children <- tags$div(
  anchor,
  class = 'name')

ui <- fluidPage(
  dashboardPage(
    
    
    # Title of the dashboard
    # dashboardHeader(header, titleWidth = 150),
    dashboardHeader(title = img(src="logo_LHC.png", height = '45', align = "right"),
                    titleWidth = 75),
    
    
    # Bar on the top + menu of the left
    dashboardSidebar(
      
      # Code to fix the ratio of the plots
      # tags$head(tags$style("#rink{padding-bottom: 90%;}")),
      tags$head(
        tags$style("#rink{
                    div.stretchy-wrapper {
                      position: relative;
                    }
                    
                    div.stretchy-wrapper > div {
                      position: absolute;
                      top: 0; bottom: 0; left: 0; right: 0;
                    }padding-bottom: 90%;}
                   
                   .content {
                      margin-top: 50px;
                    }
                    
                    .main-header {
                      position: fixed;
                      width:100%;
                    }
                   
                   .sidebar {
                      position: fixed;
                      width: 220px;
                      white-space: nowrap;
                    }"
                   )
        ),
      # tags$head(tags$style("#discrete{padding-bottom: 90%;}")),
      
      # Style for the bar on the top
      tags$head(
        tags$style(
          HTML(
            paste('.logo {
                    background-color:', col_sidebar, '!important;
                    }
                    .navbar {
                    background-color:', col_sidebar, '!important;
                    }')
            )
          )
        ),
        
        # Elements of the menu
        # Go with just two tabs: charts and informations
        sidebarMenu(
          id = "tabs",
          menuItem("Log In", tabName = "login_tab", icon = icon("sign-in-alt")),
          menuItem("Charts", tabName = "charts", icon = icon("bar-chart-o"), 
                   startExpanded = T,
                   menuSubItem("Heatmaps", tabName = "maps"),
                   TYPE_SELECT()
         #          menuSubItem("Discrete heatmap", tabName = "discrete_heatmap")
         ),
         menuItem("User guide", tabName = "guide", 
                  # This line is to add a "!" symbol. Not important.
                  badgeLabel = "!", badgeColor = "yellow",
                  icon = icon("book")),
         menuItem("Technical details", tabName = "tech", icon = icon("laptop-code")),
         menuItem("Information", tabName = "info",
                  icon = icon("info"))
    #      EXTEND_SELECT()
          
        )
    ),
    
    
    # Space where the main content (plots, text, ...) will be
    dashboardBody(
      
      # In case we need some more detailed customization:
      #includeCSS("table_html.css"),
      useShinyjs(),
      # Here we set the color of the background and of the main boxes
      tags$style(
        HTML(
          paste(
            "
            .content-wrapper,
            .right-side {
            background-color:", col_body_main, ";
            }
            
            .box.box-solid.box-primary>.box-header {
            color:", col_text, ";
            background:", col_box_plots, "
            }
            
            .box.box-solid.box-primary>.box-body {
            color:", col_text, ";
            background:", col_box_plots, "
            }
            
            .box.box-solid.box-primary>.box-footer {
            color:", col_text, ";
            background:", col_box_plots, "
            }
            
            select#nodeSelectnetwork.dropdown {
            color:", col_box_plots, "
            }
            
            #table.datatables.html-widget.html-widget-output.shiny.bound.output {
            color:", col_text, ";
            }
            
            table#DataTables_Table_0.display.dataTable.no-footer {
            color:", col_text, ";
            }
            
            table#DataTables_Table_0_length.dataTables_length.select {
            color:", col_text, ";
            }
            
            table#DataTables_Table_0_filter.dataTables_filter {
            color:", col_text, ";
            }
            
            .box {
            background:", col_box_plots, "
            }
            
            .box.box-solid.box-primary{
            border-bottom-color:", col_box_plots, ";
            border-left-color:", col_box_plots, ";
            border-right-color:", col_box_plots, ";
            border-top-color:", col_box_plots, ";
            }
            
            ")
          )
        ),
      
      # Here we add the tabs!
      tabItems(
        
        # Tab realted to the log-in
        tabItem(
          tabName = "login_tab",
          uiOutput("login")
        ),
        
        
        # In this tab we put the sliders and the heatmap boxes
        tabItem(
          tabName = "maps",
            fluidPage(
              br(),
              
              # First dropdown: general filters
              column(
                1,
                dropdown(
                  uiOutput("matches_selection"),
                  # TEAM_SELECT(),
                  uiOutput('team'),
                  style = "unite", icon = icon("gear"), 
                  status = "danger", width = "300px",
                  tooltip = tooltipOptions(
                    # title = HTML("<p>File upload &#38; team selection<p>"),
                    title = 'Generation + team selection')
                ),
                
                # Second dropdown: time filters
                dropdown(
                    PERIOD(
                    c("1"='1', "2"='2', "3"='3', "Overtime"='4'),
                    c('1', '2', '3', '4')
                  ),
                  uiOutput("time_range1"),
                  uiOutput("time_range2"),
                  uiOutput("time_range3"),
                  uiOutput("time_range4"),
                  
                  style = "unite", icon = icon("algolia"), 
                  status = "danger", width = "300px",
                  tooltip = tooltipOptions(title = "Time")
                ),
                
                # Third dropdown: shots filters
                dropdown(
                  LAYERS_SELECT(
                    c("Successful" = 'successful', "Failed" = 'failed',
                      "Goal" = 'goal'), 
                    c('successful', 'failed', 'goal')
                  ),
                  ZONE_SELECT(),
                  BLOCKED_SELECT(),
                  DEFLECTED_SELECT(),
                  style = "unite", icon = icon("hockey-puck"), 
                  status = "danger", width = "300px",
                  tooltip = tooltipOptions(title = "Shots")
                ),
                
                # Fourth dropdown: manpower filters
                dropdown(
                  LAYERS_SELECT_MANPOWER(
                    c("Even strength" = 'evenStrength', "Powerplay" = 'powerPlay', 
                      "Shorthanded" = 'shortHanded'), 
                    c('evenStrength', 'powerPlay', 'shortHanded')
                  ),
                  # Pin the place to add the checkbox UI
                  tags$div(id = 'placeholder'),
                  uiOutput("checkbox"),
                  style = "unite", icon = icon("walking"), 
                  status = "danger", width = "300px",
                  tooltip = tooltipOptions(title = "Manpower")
                ),
              
                # Fifth dropdown: players filters
                dropdown(
                  tags$div(id = 'placeholder2'),
                  uiOutput("player_shot"),
                  uiOutput("goalie"),
                  uiOutput('player_ref'),
                  uiOutput('player_position'),
                  style = "unite", icon = icon("tshirt"), 
                  status = "danger", width = "300px",
                  tooltip = tooltipOptions(title = "Players")
                ),
                
                # Sixth dropdown: graphical tools
                dropdown(
                  BIN_SLIDER(3, 10, 5),
                  SWITCH_COORD(),
                  ADD_ANGLES(),
                  # ZOOM_RATIO(),
                  style = "unite", icon = icon("redo-alt"), 
                  status = "danger", width = "300px",
                  tooltip = tooltipOptions(title = "Graphical tools")
                ),
                
                RESET()
              ),
              
              # Heatmap here
              column(
                11,
                plotlyOutput("rink", inline = T, height = "auto")
                ),
              
              status = "primary", solidHeader = T, title = strong("Heatmap")
            )
              
          ),
        
        
        # This tab will contain the user guide of the app
        tabItem(
          tabName = "guide",
          fluidPage(
            column(3),
            column(6,
              br(),
              br(),
              
              # Title
              h1(strong(span("LHC Visualization tool - User guide", 
                             style = "color:#dcddcd; font-size:42pt")), 
                 align = "center"),
              br(),
              br(),
              h3(em("NOTE: this application is just a showcase of the actual app 
                    developed for LHC."), 
                    br(), 
                    strong("It does not contain any real data, just random simulations!",
                           style = "text-decoration: underline"),
                 style = "color:#dcddcd; font-size:18pt", align = "center"),
              
              br(),
              br(),
              # Skip to the map directly
              div(
                HTML("<h3> <em> <span style='color:#dcddcd'; font-size:18pt; align:'center'> 
                     If you don't need our user guide to run the app you can freely 
                     navigate using the sidebar menu (click on the three horizontal 
                     lines on the top-left corner of your screen) </span> </em> </h3>"),
                align="center"),
              div(
                HTML("<h3> <em> <span style='color:#dcddcd'; font-size:18pt; align:'center'> 
                     <strong>or jump directly to the graphs using the action button below:
                     </strong> </span> </em> </h3>"),
                align="center"),
              # Action button that leads to the plot tab
              tags$head(
                tags$style(HTML('#go_to_maps{background-color:#dcddcd; color:#3333333}'))
              ),
              div(actionButton('go_to_maps', label = "Go to the heatmaps", 
                               icon = icon("chart-area")),
                  align="center")
            ),
            column(3)
          ),
          
          br(),
          br(),
          br(),
          
          # User guide
          fluidPage(
            column(1),
            column(10,
                   
              h3(strong("1. Introduction"), style = "color:#dcddcd; font-size:36pt"),
              span(p("This application was created in order to analyze the
                      distribution of hockey shots on the goal in one 
                      or multiple matches. Every shot is displayed on a
                      scaled representation of the hockey rink as a dot. Based on 
                      the performed shots, a heatmap summarizing the general trend
                      of the match is shown under them. The user can define
                      the information contained in the plot using a set of
                      dynamic filters in order to select only specific subsets
                      of the whole match."),
                   p("The two authors, Martin Smelik and Stefano Toffol, are
                      students from Linköping university (Sweden). They cooperated
                      with the Linköping Hockey Club (LHC) within the course of Sports
                      Analytics held by professor Patrick Lambrix. The tool was
                      created following the ideas of the goalie coach Mikael 
                      Vernblom to help in the post-match analysis of his players."),
                   style = "color:#dcddcd; font-size:16pt"
                   ),
              
              br(),
              br(),
              
              h3(strong("2. Set up"), style = "color:#dcddcd; font-size:36pt"),
              p('The application will present a random simulation of a match on
                 of a hockey rink. The original instead allowed the user to upload
                 any file(s) he/she wanted and analyze them simultaniously. 
                 The rink maintains the same proportion of its real counterpart. 
                 Since it was drawn based on the Canadian standars, the distances 
                 are expressed in feet.', 
                style = "color:#dcddcd; font-size:16pt"),
              p("The user can generate new data by clicking on the filters
                 grouped under the", icon("gear"), "icon. A dropdown menu
                 will open where the user will find. After a few seconds, needed to 
                 render the dataon screen, the interactive heatmap will be displayed,", 
                 strong("from the point of view of the Statisticians' defense."),
                "(one of the two fake teams of this demo, the second being the Mathmaticians)",
                style = "color:#dcddcd; font-size:16pt"),
              
              br(),
              br(),
              
              h3(strong("3. Heatmap"), style = "color:#dcddcd; font-size:36pt", 
                 id = "guide8_heatmap"),
              p('The heatmap presented is the main purpose of this application.
                The intent of this visualization is for both players and coaches
                to identify in a glance "hot areas" of the rink, in other words
                the locations of the field from which most of the shots come from.
                This application will also adapt the heatmap dynamically according
                to the input of the user, capable to modify and control at once several
                characteristics of the data displayed, such as the typology of the
                shots, which skaters where on the ice at the moment of the strike or
                which shots happened in a specific time window and so on (',
                a('see the filter section', href="#guide_filters", style="color:#4682b4"), 
                'for more details ).',
                style = "color:#dcddcd; font-size:16pt"),
              p('In order to compute the levels of the heatmap, the application will 
                firstly divide the hockey rink in several small squares, computing the
                empirical density of each one of them through bivariate normal kernels
                (the bandwidth and the number of points used to compute it where fixed
                to 10 and 700 respectively). It will then calculate the contour lines
                according to the number of levels provided by the user (by default 5)
                and create an adequate colour scale. Finally, it adds one by one each
                individual region to the blank plot, where the percentages shown in 
                the legend represent the proportion of density enclosed in within 
                the areas of a certain color. At the end of the procedure
                it places the dots representing the shots on top of the heatmap. 
                The .',
                style = "color:#dcddcd; font-size:16pt"),
              p('As just stated, the dots represent the shots performed during the 
                uploaded matches. The colors are symbolizing the typology of the
                outcome:', strong('blue'), 'for', strong('failed'), ',', strong('green'), 
                'for', strong('successful'), 'and', strong('red'), 'for', strong('goal'),
                '. The colors will remain constant for every match uploaded and 
                combination of filters. If one of the colors is absent, it means that 
                the current combination of matches and filters applied do not include
                any shot from that category.',
                style = "color:#dcddcd; font-size:16pt"),
              p('The plot is generated using the R library Plotly and therefore have 
                several useful properties. With this package, it is possible to 
                interact with the plots in various ways, such as zooming, saving the
                current visualization as a png file or comparing several elements
                at the same time. All of that can be done using the modebar on the 
                very top of the graph. Another practical feature is the possibility
                to hide specific elements of the plot by clicking on its representation
                in the legend bar. For instance, clicking on one of the dots within
                the legend will make the corresponding shots on the plot, otherwise 
                visible, disappear. Clicking once more on the now shadowed element of
                the legend will revert the dots on the plot. This behavior is present 
                also for any level of the actual heatmap. Remember that any of these
                traces of the legend can be isolated with a double click on that element.
                The zoom level can be reset to its starting point with a double-click
                as well, but this time on the plot.',
                style = "color:#dcddcd; font-size:16pt"),
              p('Furthermore hovering the mouse over the data points will make a 
                box appear on screen. The background of the box is colored according
                to the outcome of the shot and contains several useful information 
                regarding the shot performed. The hover will reveal the',
                strong('full name of the shooter'), ', the', 
                strong('distance from the goal'), '(computed in feet), the',
                strong('angle from the goal'), '(computed in degrees) and the',
                strong('full name of the defending goalie'), '.',
                style = "color:#dcddcd; font-size:16pt"),
              
              br(),
              
              tags$ul(style = "color:#dcddcd; font-size:20pt; margin-top:30px;
                               list-style-type:none",
                      
                tags$li(
                  # Descibing the types of heatmap
                  p(em("Types of heatmap")),
                  p("This app is provided with three different typologies of maps.
                    They are accessible from the sidebar menu (initially collapsed in
                    the icon ", icon("bars"), " on the top-left corner of the screen) 
                    under the section \"Charts\", sub-menu \"Heatmaps\". The user can
                    choose between three different options: ", strong("continuous"),
                    ", ", strong("discrete"), " and ", strong("extended"), ".",
                    style = "color:#dcddcd; font-size:16pt"),
                  p("The ", strong("continuous"), "heatmap is the type selected
                    by default. It will simply show the visualization of the uploaded 
                    matches in the ways described before.", br(), "The ", 
                    strong("discrete"), " map instead show a representation 
                    of the game(s) shots without the kernel density heatmap. It 
                    instead divides the hockey rink in nine sectors (four triangular
                    one at the left of the goal, other identical four on the right 
                    of the goal and one last rectangular sector between the central
                    and the blue line). This division was decided together with LHC's
                    hockey coach. Each sector is colored in shades of green according
                    to the proportion of shots coming from that specific sector. A brief
                    text depicts the exact number and percentage for each of them.
                    This tool is meant to be a more intuitive, yet less accurate,
                    of the preferred angles of attack of the opposing team.", br(),
                    "Lastly, the ", strong("extended"), "version of the map 
                    appears similar to the discrete one. However in this case the
                    shades of colour and the numbers written will represent a 
                    comparison with the average computed over the whole past season.
                    Since the number of shots from a certain sector within the
                    uploaded game(s) may be inferior to the average, the shades of
                    color will go from red (negative values) to green (positive values).
                    In order for the plot to work, one needs to", 
                    em("upload a .RData file containing the combined games 
                       from the whole 2017/2018 season."), br(),                       
                    em("IMPORTANT: the average is not reactive for some of the filters.
                        In other words, when the user is applying on of the following filters: ",
                       strong("Matches selection"), ',',strong("Team"), ',' , strong("Goalie"),
                       ',', strong("Shooters"), 'or', strong("Players on ice"), ", the average
                       to which we compare will remain the same as before using the filter.", 
                       style = "text-decoration: underline"),
                    style = "color:#dcddcd; font-size:16pt")
                )
              ),
              
              br(),
              br(),
              
              h3(strong("4. Filters"), style = "color:#dcddcd; font-size:36pt",
                 id = "guide_filters"),
              p("This application is provided with a set of filters, grouped
                 according to their function. Each filter will determine
                 which subsets of shots to display in the plot (i.e. if only
                 the third period is selected, the app will display only
                 the shots that happened during that time). Every filter will
                 start, by default, by having all possible values selected
                 (i.e. all shots from all games will be displayed after 
                 loading the file). If the user deselect some values from a 
                 filter, the shots with the deselected values will not be 
                 plotted (i.e. putting out period 1 will exclude these shots
                 from the plot).", 
                style = "color:#dcddcd; font-size:16pt"),
              p("Every change to the filters will result in 
                 an almost immediate change in the plot. The filters can consist
                 of: dropdown menus, like the type of shot or the manpower; 
                 checkboxes, like the periods; sliders, for numeric variables 
                 such as the time passed from the beginning of a certain period. 
                 Moreover some of the filters are also dynamic, meaning that are 
                 generated on the fly, according to the values selected by the 
                 user in other filters (i.e. the players on ice will depend on 
                 the periods selected).", 
                style = "color:#dcddcd; font-size:16pt"),
              p("We will now see in details what each filter does, how they are 
                 grouped and how they interact with each other.",
                style = "color:#dcddcd; font-size:16pt"),
              br(),
              
              
              # Bulleted list with every group of filter
              tags$ul(style = "color:#dcddcd; font-size:20pt; margin-top:30px",
                
                tags$li(
                  # First group: the file upload
                  p(icon("gear"), em("File upload & matches management")),
                  p("This menu consists of two filters dedicated to the upload 
                    of the needed file(s) and other two filters used to select which
                    matches to view and which team was on posession.",
                    style = "color:#dcddcd; font-size:16pt"),
                  # Detailed description of each filter with custom HTML list
                  HTML(
                    '<ul class="fa-ul"; style="margin-top:25px">
                      <li><span class="fa-li"; style="color:#dcddcd; font-size:16pt">
                      <i class="fas fa-angle-double-right fa-xs"></i></span>
                      <span style="color:#dcddcd; font-size:16pt"><p>Choose CSV file</p>
                      <p>Through this widget the user can upload the file(s) of 
                      interest by clicking on the "Browse..." icon. The app 
                      will show a progress bar while reading the files.<br>Shortly 
                      after the loading process is completed, the graphical 
                      representation of the match(es) will appear on the screen.</p></span></li>
                      <li><span class="fa-li"; style="color:#dcddcd; font-size:16pt">
                      <i class="fas fa-angle-double-right fa-xs"></i></span>
                      <span style="color:#dcddcd; font-size:16pt"><p>Choose all data file</p>
                      <p>In this filter the user can upload the data collected from 
                      the previous season. The file will be used to compute the plots in
                      the extended version of the heatmap (<a href="#guide_heatmap"
                      style="color:#4682b4">see the heatmap section</a>).<br>The format 
                      of the data file requested is a .RData containing a pre-processed
                      version of all the games played by LHC in the previous season.
                      The file was provided to the team beforehand.</p></span></li>
                      <li><span class="fa-li"; style="color:#dcddcd; font-size:16pt">
                      <i class="fas fa-angle-double-right fa-xs"></i></span>
                      <span style="color:#dcddcd; font-size:16pt"><p>Matches selection</p>
                      <p>This filter will appear only after the data has been loaded.<br>
                      In case that the user wants to analyze more than one game,
                      he/she will be able to choose which matches to display on
                      screen. By default all matches will be considered for the plot.<br>
                      Each game is labeled automatically using the original name
                      of the file, from which the teams (home vs away) and the date of 
                      the game(s) are extracted.</p></span></li>
                      <li><span class="fa-li"; style="color:#dcddcd; font-size:16pt">
                      <i class="fas fa-angle-double-right fa-xs"></i></span>
                      <span style="color:#dcddcd; font-size:16pt"><p>Team</p>
                      <p>This filter will appear only after the data has been loaded.<br>
                      The user can decide which team was attacking, determining who 
                      was in possession when the shots were made. If the selected 
                      team is present in more than one of the chosen matches, the
                      plot will display all their shots performed in all the chosen 
                      games.<br>Consider that if two selected clubs have played against
                      each other, the shots from both will appear simultaneously
                      in the rink.<br>By default only the first team in alphabetical 
                      order is selected.</p></span></li>
                    </ul>'
                  )
                ),
                
                br(),
                
                tags$li(
                  # Second group: time management
                  p(icon("algolia"), em("Time management")),
                  p("This menu consists of a set of filters dedicated to the selection
                    of periods within a game. An ulterior selection of sub-intervals 
                    of a specific period is possible, allowing the user to analyze
                    a specific time window within each period.",
                    style = "color:#dcddcd; font-size:16pt"),
                  # Detailed description of each filter with custom HTML list
                  HTML(
                    "<ul class='fa-ul'; style='margin-top:25px'>
                      <li><span class='fa-li'; style='color:#dcddcd; font-size:16pt'>
                      <i class='fas fa-angle-double-right fa-xs'></i></span>
                      <span style='color:#dcddcd; font-size:16pt'><p>Periods checkboxes</p>
                      <p>With this filter the user is able to choose if including or
                      not a period in the analysis. Checking/unchecking the box
                      corresponding to the desired period will result in an immediate 
                      inclusion/exclusion of the shots from that period in the plot.
                      These changes will have effect for all the selected matches
                      (in case the user uploaded more than one CSV file).<br>
                      Note that the fourth checkbox, corresponding to the overtime,
                      will always be present in this tool, no matter if the event
                      occurred or not in the uploaded file(s). In those cases, checking
                      or unchecking it will not cause any change to the plot.<br>
                      By default the visualization starts with all periods checked.
                      </p></span></li>
                      <li><span class='fa-li'; style='color:#dcddcd; font-size:16pt'>
                      <i class='fas fa-angle-double-right fa-xs'></i></span>
                      <span style='color:#dcddcd; font-size:16pt'><p>Periods sliders</p>
                      <p>This filters will appear only after the data has been loaded.<br>
                      For each available period (overtime will not be included if absent
                      in the file) a dedicated slider will allow the user to further 
                      refine the time selection of a single period. In fact the two 
                      indicators of the slider are both interactive and will identify,
                      for each period, a time interval during which shots were made.
                      The minimum and the maximum of that interval consist, respectively, 
                      of the left and right indicator of the slider. In other words,
                      if the user define the interval [5,15] for the first period,
                      only the shots happening after 5'00'' and before 15'00'' will
                      appear on the screen (to respect of period 1). Note that this tool
                      does not allow the user to select multiple time intervals
                      within the same period nor to divide an interval in any way.<br>
                      A small lag will cause a slight delay in the response of the app 
                      with respect to the sliders. This behavior is intended and is 
                      necessary to avoid potential crashes or infinite loops of the app.
                      <br>By default each sliders will start off including the whole 
                      time of the period.</p></span></li>
                    </ul>"
                  )
                ),
                
                br(),
                
                tags$li(
                  # Third group: shots
                  p(icon("hockey-puck"), em("Shots filters")),
                  p("This group of filters are all related to some characteristics 
                    of the shots. The user will be able to filter out deflected shots,
                    blocked shots, the zone from which it came from and the type
                    of the shot outcome.", style = "color:#dcddcd; font-size:16pt"),
                  # Detailed description of each filter with custom HTML list
                  HTML(
                    "<ul class='fa-ul'; style='margin-top:25px'>
                      <li><span class='fa-li'; style='color:#dcddcd; font-size:16pt'>
                      <i class='fas fa-angle-double-right fa-xs'></i></span>
                      <span style='color:#dcddcd; font-size:16pt'><p>Type of the shots</p>
                      <p>The shots are normally classified based on their outcome. They
                      are defined '<b>successful</b>' if the puck reached the goal (not
                      necessarily crossing the line) and '<b>failed</b>' if it missed or 
                      was blocked/deflected by a non-goalie skater. There may also be 
                      '<b>undetermined</b>' shots in case it was not possible to understand 
                      what happened exactly during that play. Finally, the shots that 
                      resulted in a score are naturally labeled as '<b>goal</b>'.<br>
                      The type of the shots determines the color of the dots in the
                      graph (as described <a href='#guide_heatmap' style='color:#4682b4'>
                      in the heatmap section</a>). The user can choose which ones to
                      look at in the plot by checking/unchecking the corresponding
                      entry. By default all possible outcomes are displayed.
                      </p></span></li>
                      <li><span class='fa-li'; style='color:#dcddcd; font-size:16pt'>
                      <i class='fas fa-angle-double-right fa-xs'></i></span>
                      <span style='color:#dcddcd; font-size:16pt'><p>Zone of the shots</p>
                      <p>The shots have been classified based on their proximity to the
                      goal as well. The app distinguish between shots that were stroke
                      inside the so-called '<b>slot</b>' area or <b>outside</b> of it.
                      Checking/unchecking the corresponding entry will include/exclude
                      this type of shot in the plot. By default both types are shown.
                      </p></span></li>
                      <li><span class='fa-li'; style='color:#dcddcd; font-size:16pt'>
                      <i class='fas fa-angle-double-right fa-xs'></i></span>
                      <span style='color:#dcddcd; font-size:16pt'><p>Blocked shots</p>
                      <p>The shots on net were labeled in the data as '<b>blocked</b>' 
                      in case they were intercepted by a non-goalie skater. All the other
                      shots were therefore defined as '<b>unblocked</b>'. Note that
                      the two categories may consist of both deflected or straight
                      shots (see next sub-section).<br>Checking/unchecking the 
                      corresponding entry will include/exclude this type of shot in the plot.
                      </p></span></li>
                      <li><span class='fa-li'; style='color:#dcddcd; font-size:16pt'>
                      <i class='fas fa-angle-double-right fa-xs'></i></span>
                      <span style='color:#dcddcd; font-size:16pt'><p>Deflected shots</p>
                      <p>The data available was also precise enough to determine 
                      whether or not the shots have been deflected by any non-goalie
                      skater. These attempts were labeled as '<b>deflected</b>', which
                      led to define as '<b>straight</b>' all the other shots.<br>
                      Checking/unchecking the corresponding entry will include/exclude 
                      this type of shot in the plot.
                      </p></span></li>
                    </ul>"
                  )
                ),
                
                br(),
                
                tags$li(
                  # Fourth group: manpower management
                  p(icon("walking"), em("Manpower filters")),
                  p("The two filters of this section depic the manpower situation
                    in the field for each shot. In fact some infractions in hockey 
                    result in penalties, which will send the offending player to
                    the penalty box: his team will have to play with one less skater
                    for a designed amount of time.", style = "color:#dcddcd; font-size:16pt"),
                  # Detailed description of each filter with custom HTML list
                  HTML(
                    "<ul class='fa-ul'; style='margin-top:25px'>
                      <li><span class='fa-li'; style='color:#dcddcd; font-size:16pt'>
                      <i class='fas fa-angle-double-right fa-xs'></i></span>
                      <span style='color:#dcddcd; font-size:16pt'><p>Manpower differential</p>
                      <p>The filter summarizes the manpower condition from the perspective
                      of LHC. A situation of numeric advantage over the opponent is 
                      defined as '<b>Powerplay</b>', the opposite is called 
                      '<b>Shorthanded</b>' and when the two teams are equal in numbers 
                      '<b>Even strength</b>'. Checking/unchecking the corresponding 
                      entry will show the shots that happened under that condition<br>
                      Note that chaotic situations on the field or ongoing changes of
                      players may cause unreliable records on the data (i.e. an ongoing
                      change may seem like an extra skater is on the field). For this
                      reason, despite the correct functioning of the app, the plot may
                      describe a situation that never happened during the match.<br>
                      By default all the different situations are selected.
                      </p></span></li>
                      <li><span class='fa-li'; style='color:#dcddcd; font-size:16pt'>
                      <i class='fas fa-angle-double-right fa-xs'></i></span>
                      <span style='color:#dcddcd; font-size:16pt'><p>Players on ice (number)</p>
                      <p>This filters will appear only after the data has been loaded.<br>
                      For a more detailed analysis of the manpower differential, 
                      the user can choose the events that happened with an exact number
                      of skaters in each site. There are various checkboxes, each one
                      representing the players on ice when a shot was made. The entry
                      of the boxes are in the form '<b>Number of home team players versus
                      number of away team players</b>'. The checkboxes available are
                      determined by the choices of the other filters.<br>The reliability
                      of this filter is affected by the same problem in the data recording 
                      mentioned before (in Manpower differential).
                      </p></span></li>
                    </ul>"
                  )
                ),
                
                br(),
                
                tags$li(
                  # Fifth group: player management
                  p(icon("tshirt"), em("Players filters")),
                  p("The four filters of this section will allow the user to choose
                    shots coming from a specific player, who was the goalie, the role
                    of the shooter and which players where on ice in the moment
                    the shots happened.", style = "color:#dcddcd; font-size:16pt"),
                  # Detailed description of each filter with custom HTML list
                  HTML(
                    "<ul class='fa-ul'; style='margin-top:25px'>
                      <li><span class='fa-li'; style='color:#dcddcd; font-size:16pt'>
                      <i class='fas fa-angle-double-right fa-xs'></i></span>
                      <span style='color:#dcddcd; font-size:16pt'><p>Shooters</p>
                      <p>This filter will appear only after the data has been loaded.<br>
                      The menu allows the user to see the shots of one or more
                      specific player. A list of all the shooters is generated as
                      soon as the data is loaded and ordered alphabetically (only the
                      surnames are considered). Checking/unchecking the name of a 
                      certain player will make his shots appear/disappear from the
                      screen. In order to facilitate the use of the filter, a button 
                      to select and to deselect all players at once is also available.<br>
                      Note that if multiple matches have been uploaded, deselecting one
                      of the matches will not cause any change in this list of players,
                      neither will change their selection/deselection. This means that
                      the names of players from a team temporarily deselected will remain
                      in the list nonetheless. Interacting with these players will not
                      have any effect on the current visualization. The same happens when
                      the user is interactive with a player from the home team but is
                      viewing the match from the perspective of the away team's defense.
                      This issue is present on all the filters of this section.<br>
                      By default all the shooters of the game(s) are selected.
                      </p></span></li>
                      <li><span class='fa-li'; style='color:#dcddcd; font-size:16pt'>
                      <i class='fas fa-angle-double-right fa-xs'></i></span>
                      <span style='color:#dcddcd; font-size:16pt'><p>Goalie</p>
                      <p>This filter will appear only after the data has been loaded.<br>
                      With this filter the user can decide who was the goalie defending.
                      An alphabetically ordered list of all the goalkeepers present in 
                      the uploaded match(es) is generated as soon as the data is loaded  
                      (only the surnames are considered). Selecting/deselecting a name
                      will make appear/disappear the shot during which he was in the 
                      goal. This filter will have effect only if the team selected in
                      the filter <i>General-->Team</i> is the opposing team.<br>
                      This filter is affected by the same issue of the Shooters.
                      </p></span></li>
                      <li><span class='fa-li'; style='color:#dcddcd; font-size:16pt'>
                      <i class='fas fa-angle-double-right fa-xs'></i></span>
                      <span style='color:#dcddcd; font-size:16pt'><p>Players on ice</p>
                      <p>This filter will appear only after the data has been loaded.<br>
                      This filter will allow the user to see the shots that happened
                      when a certain set of players was on ice. Their presence on the 
                      rink does not necessarily mean their direct involvement in the 
                      action leading to the shot. As in the previous filters, a list
                      with all the surname of the players involved in the loaded matches
                      is generated automatically and alphabetically ordered. This time 
                      though the menu start with all entries deselected: checking a
                      name force the app to show shots when that specific player was
                      on ice. More than one name selected means that all the chosen
                      players must have been on ice at the moment of the shot.<br>
                      The behavior of this filter is then the same of the previous 
                      ones in this subsection.
                      </p></span></li>
                      <li><span class='fa-li'; style='color:#dcddcd; font-size:16pt'>
                      <i class='fas fa-angle-double-right fa-xs'></i></span>
                      <span style='color:#dcddcd; font-size:16pt'><p>Shooter's role</p>
                      <p>This filter will appear only after the data has been loaded.<br>
                      With this filter the user can choose the shooters based on their
                      role (abbreviated).<br>
                      By default all roles of the shooters are selected.
                      </p></span></li>
                    </ul>"
                  )
                ),
                
                br(),
                
                tags$li(
                  # Sixth group: graphical tools
                  p(icon("redo-alt"), em("Graphical filters")),
                  p("The three filters in this section allow the user to adjust some
                    graphical aspects of the plot.", style = "color:#dcddcd; font-size:16pt"),
                  # Detailed description of each filter with custom HTML list
                  HTML(
                    "<ul class='fa-ul'; style='margin-top:25px'>
                      <li><span class='fa-li'; style='color:#dcddcd; font-size:16pt'>
                      <i class='fas fa-angle-double-right fa-xs'></i></span>
                      <span style='color:#dcddcd; font-size:16pt'><p>Number of shades</p>
                      <p>This filter will appear only after the data has been loaded.<br>
                      The slider allows the user to define the interpolation levels
                      of the heatmap. In other words, it sets the discretization of
                      the density, telling to the app how many contour levels should
                      draw for the contour lines. Visually, it means it will change 
                      the color scale of the heatmap, adding or subtracting color 
                      levels from the present scheme.<br>
                      By default the slider starts with 5 levels selected. Therefore,
                      it's necessary to sometimes adjust the number of shades in order
                      to have a meaningful visualization: sparse data may lead to
                      isolated points, with loose density between each point. In those
                      cases the default level of the slider may not produce a visible
                      heatmap and hence needs to be increased.
                      </p></span></li>
                      <li><span class='fa-li'; style='color:#dcddcd; font-size:16pt'>
                      <i class='fas fa-angle-double-right fa-xs'></i></span>
                      <span style='color:#dcddcd; font-size:16pt'><p>Flip plot</p>
                      <p>This tool will appear only after the data has been loaded.<br>
                      Clicking on the rotate button will flip the plot from a vertical
                      orientation to a horizontal one (or vice versa). Both visualizations
                      will still represent only one half of the field.
                      </p></span></li>
                      <li><span class='fa-li'; style='color:#dcddcd; font-size:16pt'>
                      <i class='fas fa-angle-double-right fa-xs'></i></span>
                      <span style='color:#dcddcd; font-size:16pt'><p>Zone division</p>
                      <p>This filter will appear only after the data has been loaded.<br>
                      With this filter the user can show/hide a zone division of the
                      slot area. This button will visually divide the area in 8 
                      symmetric sectors.
                      </p></span></li>
                    </ul>"
                  )
                ),
                
                br(),
                
                tags$li(
                  # Seventh group: reset button
                  p(icon("minus-circle"), em("Reset button")),
                  p("The button functions as a resort tool in case the user is confused 
                    about what filters are currently in use. Clicking it will reset
                    the graph to default setting, with data that were already loaded.",
                    style = "color:#dcddcd; font-size:16pt")
                )
              )
            ),
            column(1)
          ) 
        ),
        
        
        # This tab contains information about the tools and methods used
        tabItem(
          tabName = "tech",
          br(),
          br(),
          h1(strong(span("Tools and methods",
                         style = "color:#dcddcd; font-size:42pt")), align = "center"),
          fluidPage(
            column(1),
            column(
              10,
              h3("This application was built in its entirety in R and uses several
                 packages (also called libraries) and functions contained in it.
                 In order to style the application as it is now, some HTML code
                 had to be written. What follows is a brief list of the libraries
                 used for each aspect of the app:",
                 style = "color:#dcddcd; font-size:18pt", align = "center"),
              
              tags$ul(
                style = "color:#dcddcd; font-size:20pt; margin-top:30px;",
                
                tags$li(
                  p(em("Application")),
                  p("Packages used:", em("shiny; shinydashboard; shinyBS; shinyjs"), 
                    br(),
                    "Several functions from all the packages listed were used.",
                  style = "color:#dcddcd; font-size:16pt")
                  ),
                tags$li(
                  p(em("Filters")),
                  p("Packages used:", em("shinyWidgets"),
                    br(),
                    "All the visible filters were built using this package: 
                    the function", em("pickerInput"), "for the selectable menus;
                    the function", em("sliderInput"), "for the period and heatmap's 
                    levels sliders;
                    the function", em("actionBttn"), "for the clickable buttons;
                    the function", em("fileInput"), "to allow uploading the matches;
                    the function", em("actionBttn"), "for the clickable buttons.",
                    style = "color:#dcddcd; font-size:16pt")
                ),
                tags$li(
                  p(em("Heatmap")),
                  p("Packages used:", em("plotly; MASS; grDevices"),
                    br(),
                    "The hockey rink was drawn exploiting the", em("layout(.)"), 
                    "function of", em("plotly"), ", as well as the division of the 
                    field in sectors; the dots and the actual heatmap were displayed
                    with different functions from the same package, with",
                    em("add_polygons(.)"), "being the most important for the 
                    actual heatmap; the function", em("kde2d(.)"), "from the package",
                    em("MASS"), "allowed us to compute the kernel density estimation
                    while the function", em("contourLines(.)"), "from the library",
                    em("grDevices"), "divided the estimates in the desired amount
                    of levels.",
                    style = "color:#dcddcd; font-size:16pt")
                ),
                tags$li(
                  # Descibing the types of heatmap
                  p(em("Pre-processing of the data")),
                  p("Packages used:", em("dplyr; stringr"),
                    br(),
                    "The library", em("dplyr"), "contains several useful functions
                    to clean, manipulate and reshape the data as wanted; the library",
                    em("stringr"), "was needed to extract or change the text contained
                    in several variables of the data.", 
                    style = "color:#dcddcd; font-size:16pt")
                )
              ),
            column(1))
          )
        ),
        
        
        # This tab contains information about the authors and the project
        tabItem(
          tabName = "info",
            br(),
            br(),
            h1(strong(span("Linköping University", 
                           style = "color:#dcddcd; font-size:42pt")), 
               align = "center"),
            h3(strong(em(span("Master's course in Statistics and Machine Learning", 
                              style = "color:#dcddcd; font-size:18pt"))), 
               align = "center"),
            h3(em(span("Subject: Sports Analytics (Professor: Patrick Lambrix)", 
                       style = "color:#dcddcd; font-size:18pt")), 
               align = "center"),
            h3(em(span("Visualization of goalkeepers' data for LHC team", 
                       style = "color:#dcddcd; font-size:18pt")), 
               align = "center"),
            br(),
            h5(span("Authors: ", 
                    style = "color:#dcddcd; font-size:15pt"), 
               br(),
               span("Stefano Toffol (steto820)", 
                    style = "color:#dcddcd; font-family:georgia; font-size:15pt; 
                    padding-left:0.35em"),
               br(),
               span("Martin Smelik (marsm914)", 
                    style = "color:#dcddcd; font-family:georgia; font-size:15pt; 
                    padding-left:0.35em"),
               br(),
               align = "center"),
            h5(span("Authors emails: ", 
                    style = "color:#dcddcd; font-size:15pt"), 
               br(),
               span("steto820@student.liu.se", 
                    style = "color:#dcddcd; font-family:georgia; 
                    font-size:15pt; padding-left:0.35em"),
               br(),
               span("marsm914@student.liu.se", 
                    style = "color:#dcddcd; font-family:georgia; 
                    font-size:15pt; padding-left:0.35em"),
               align = "center"),
            br(),
            br(),
            br(),
            br(),
            br(),
            br(),
            br(),
            HTML(
              '<footer>
              <style>p.indent{ padding-left: 2.4em; color:#dcddcd}</style>
              <p class="indent">Last update: 2019/10/17</p>
              </footer>'
            )
        )
      )
    )
  )
)        