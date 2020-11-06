library(ggplot2)
library(plotly)
library(MASS)
library(dplyr)
library(sp)

source("R/hockey_rink_vert.R")
source("R/preprocess_file_fun.R")
source("R/preprocess_file_2_fun.R")
source("R/get_discrete_plot.R")
source("R/get_discrete_plot_vs_average.R")
source("R/autentication.R")
source("R/generation.R")
source("R/players.R")
players <- players_fun()



server <- function(input, output, session){
  
  player_position_init <- TRUE
  checkbox_init <- TRUE
  player_shot_init <- TRUE
  player_ref_init <- TRUE
  player_goalie_init <- TRUE
  player_team_init <- TRUE
  matches_selection_init <- TRUE
  opacity <- 1
  bandwidth <- 10
  nlevels <- 20
  smoothness <- 700
  line_width <- 0.5
  line_color <- "white"
  # den_color <- c("#c4c9ed","#0010a8")
  # den_color <- c("#cde33b", "#582766")
  # den_color <- c("#ff0000", "#5b0000")
  den_color <- c("#b79b32", "#5b3203")
  
  addClass(selector = "body", class = "sidebar-collapse")
  USER <- reactiveValues(Logged = Logged)
  orientation <- reactiveValues(Orientation = "Vertical")
  
  observe({
    if (USER$Logged == FALSE) {
      if (!is.null(input$Login)) {
        if (input$Login > 0) {
          Username <- isolate(input$userName)
          Password <- isolate(input$passwd)
          Id.username <- which(my_username == Username)
          Id.password <- which(my_password == Password)
          if (length(Id.username) > 0 & length(Id.password) > 0) {
            if (Id.username == Id.password) {
              USER$Logged <- TRUE
              print("You signed in succesfully")
              updateTabItems(session, "tabs", "guide")
            }
          }
        }
      }
    }
  })
  
  observe({
    if (USER$Logged == FALSE) {
      
      output$login <- renderUI({
        div(class="outer",do.call(bootstrapPage,c("", ui_autentication())))
      })
    }
    
    if (USER$Logged == TRUE) {
      
      values <- reactiveValues(data = NULL,
                               data_season = NULL,
                               data_preprocess = NULL,
                               data_preprocess2 = NULL,
                               data_preprocess_season = NULL,
                               data_preprocess2_season = NULL,
                               time_range1 = c(0, 20),
                               time_range2 = c(20, 40),
                               time_range3 = c(40, 60),
                               time_range4 = NULL,
                               layout = rink_shapes)
      
      base_plot <- plot_ly() %>%
        layout(shapes = rink_shapes, showlegend = T, plot_bgcolor = "#f4f4f4",
               paper_bgcolor = "#f4f4f4",
               xaxis = list(title = list(text ="")),
               yaxis = list(title = list(text = ""), #visible=F),
                            scaleanchor = "x", scaleratio = 0.9)) #visible=F),
      
      # Check if the user jumps from user guide tab to heatmap tab directly
      observeEvent(input$go_to_maps, {
        updateTabsetPanel(session, "tabs", selected = "maps")
      })
      
      
      ##-------------GET DATA----------------------------------------
      
      game <- generation()
      
      max_time <<- ceiling(max(game$gameTime)/60)
      values$data <- game
  
      ##-------------READ ALL SEASON DATA--------------------------------
      
      observeEvent(input$switch, {
        print("Inside switch")
        orientation$Orientation <- switch(orientation$Orientation,
                                          "Vertical" = "Horizontal",
                                          "Horizontal" = "Vertical")
        if(orientation$Orientation=="Vertical") {
          source("R/hockey_rink_vert.R")
        }
        if(orientation$Orientation=="Horizontal") {
          source("R/hockey_rink_horiz.R")
        }
        new_ycoord <- values$data$xAdjCoord
        new_xcoord <- values$data$yAdjCoord
        values$data$yAdjCoord <- new_ycoord
        values$data$xAdjCoord <- new_xcoord
        base_plot <<- plot_ly() %>%
          layout(shapes = rink_shapes, showlegend = T, plot_bgcolor = "#f4f4f4",
                 paper_bgcolor = "#f4f4f4",
                 xaxis = list(title = list(text ="")),
                 yaxis = list(title = list(text = ""), #visible=F),
                              scaleanchor = "x", scaleratio = 0.9)) 
        choose_plot()
      })
      
      values$data_season <- values$data_season
      
      
      ##--------------------------PREPROCESS FILE --------------------
      
      preprocess_file <- reactive({

       values$data_preprocess <- preprocess_file_fun(values$data)
    
      })
      
      
      ##-------------------------PREPROCES FILE ALL SEASON ------------------------        
      
      preprocess_file_season <- reactive({
        if (input$type == "extended") {
          
    
        values$data_preprocess_season <- preprocess_file_fun(values$data_season)
        }
      })
      
      
      ##-------------------------CHECKBOX MAGIC------------------------------------
      
      output$checkbox <- renderUI({
        if(checkbox_init == TRUE){
          choices_checkbox <- unique(values$data_preprocess$numPlayers)
          selected <- choices_checkbox
          checkbox_init <<- FALSE
        }
        
        if(length(setdiff(unique(values$data_preprocess$numPlayers), choices_checkbox) %in% choices_checkbox) == 0){
          selected <- input$checkbox
        }
        else{
          selected <- c(input$checkbox, setdiff(unique(values$data_preprocess$numPlayers), choices_checkbox))
        }
        
        # if(is.null(input$checkbox)){choices_checkbox <- unique(values$data_preprocess$numPlayers)}
        # 
        # if(is.null(input$checkbox)){selected <- unique(values$data_preprocess$numPlayers)}
        # else{
        #   if(length(setdiff(unique(values$data_preprocess$numPlayers), choices_checkbox) %in% choices_checkbox) == 0){
        #     selected <- input$checkbox
        #   }
        #   else{
        #     selected <- c(input$checkbox, setdiff(unique(values$data_preprocess$numPlayers), choices_checkbox))
        #   }
        # }
        
        choices_checkbox <<- unique(values$data_preprocess$numPlayers)
        
        #   else {selected <- c(input$checkbox, setdiff(choices, unique(values$data_preprocess$numPlayers)))}
        tipify(checkboxGroupInput("checkbox", "Players on ice", choices = choices_checkbox,
                                  selected = selected, inline = T),
               "Number of players in the rink (home vs away team)", placement = "right")
      })
      outputOptions(output, "checkbox", suspendWhenHidden=FALSE)
      
      
      output$goalie <- renderUI({
        
        if(player_goalie_init == TRUE){
          choices_goalie <- sort(unique(values$data_preprocess$goalieLastName))
          selected <- choices_goalie
          player_goalie_init <<- FALSE
        }
        
        if(length(setdiff(unique(values$data_preprocess$goalieLastName), choices_goalie) %in% choices_goalie) == 0){
          selected <- input$goalie
        }
        else{
          selected <- c(input$goalie, setdiff(unique(values$data_preprocess$goalieLastName), choices_goalie))
        }
        
        
        
        choices_goalie <<- sort(unique(values$data_preprocess$goalieLastName))
        tipify(fluidRow(
          column(3, tags$label("Goalie")),
          column(9, pickerInput('goalie',
                                multiple = TRUE,
                                label = NULL,
                                choices = as.character(choices_goalie),
                                selected = as.character(selected),
                                options = list(
                                  `actions-box` = TRUE, 
                                  # size = 10,
                                  `selected-text-format` = "count > 3"
                                )))),
          "Who was the goalkeeper?", placement = "right")
      })
      outputOptions(output, "goalie", suspendWhenHidden=FALSE)
      
      output$matches_selection <- renderUI({
        

        if(matches_selection_init == TRUE){
          choices_matches <- unique(values$data_preprocess$Match)
          selected <- choices_matches
          matches_selection_init <<- FALSE
        }
        

        if(length(setdiff(unique(values$data_preprocess$Match), 
                          choices_matches) %in% choices_matches) == 0){
          selected <- input$matches_selection
        }
        else{
          selected <- c(input$matches_selection, 
                        setdiff(unique(values$data_preprocess$Match), choices_matches))
        }
        
        choices_matches <<- unique(values$data_preprocess$Match)
        tipify(fluidRow(
          column(3, tags$label("Matches selection")),
          column(9, pickerInput('matches_selection',
                                multiple = TRUE,
                                label = NULL,
                                choices = as.character(choices_matches),
                                selected = as.character(selected),
                                options = list(
                                  `actions-box` = TRUE, 
                                  # size = 10,
                                  `selected-text-format` = "count > 3"
                                )))),
          "Which matches you want to display?", placement = "right")
      })
      outputOptions(output, "matches_selection", suspendWhenHidden=FALSE)
      
      output$player_ref <- renderUI({
        
        if(player_ref_init == TRUE){
          choices_ref <- unique(values$data_preprocess$playerReferenceId)
          selected <- NULL
          player_ref_init <<- FALSE
        }
        
        # if(length(setdiff(unique(values$data_preprocess$playerReferenceId), choices_ref) %in% choices_ref) == 0){
        #   selected <- input$player_ref
        # }
        # else{
        #   selected <- c(input$player_ref, setdiff(unique(values$data_preprocess$playerReferenceId), choices_ref))
        # }
        # 
        selected <- input$player_ref
        
        choices_ref <<- unique(values$data_preprocess$playerReferenceId)
        cat("Choiches ref: ", choices_ref)
        player_name <- choices_ref
        player_surname <- choices_ref
        for(i in (1:length(choices_ref))){

          if(length(players[which(choices_ref[i] == players[,1]),2]) > 0){
          player_name[i] <- players[which(choices_ref[i] == players[,1]),2]
          player_surname[i] <- players[which(choices_ref[i] == players[,1]),3]
          }
        }
        matrix_players <- cbind(player_name, player_surname)
        if(!is.null(matrix_players)) {
          cat("Matrix player is not null")
          matrix_players <- matrix_players[order(matrix_players[,2]),] 
        }
        name <- paste0(matrix_players[,2], ', ', matrix_players[,1])
        
        names(choices_ref) <- name
        
        
        tipify(fluidRow(
          column(3, tags$label("Players on ice")),
          column(9, pickerInput('player_ref',
                                multiple = TRUE,
                                label = NULL,
                                choices = choices_ref,
                                selected = selected,
                                options = list(
                                  `actions-box` = TRUE, 
                                  # size = 10,
                                  `selected-text-format` = "count > 3"
                                )))),
          "Who played at the time?", placement = "right")
      })
      outputOptions(output, "player_ref", suspendWhenHidden=FALSE)
      
      
      output$team <- renderUI({
        
        if(player_team_init == TRUE){
          choices_team <- unique(values$data_preprocess$teamInPossession)
          selected <- choices_team
          player_team_init <<- FALSE
        }
        
        if(length(setdiff(unique(values$data_preprocess$teamInPossession), choices_team) %in% choices_team) == 0){
          selected <- input$team
        }
        else{
          selected <- c(input$team, setdiff(unique(values$data_preprocess$teamInPossession)[1], choices_team))
        }
        
        
        choices_team <<- unique(values$data_preprocess$teamInPossession)
        tipify(fluidRow(
          column(3, tags$label("Team")),
          column(9, pickerInput('team',
                                multiple = TRUE,
                                label = NULL,
                                choices = as.character(choices_team),
                                selected = as.character(selected),
                                options = list(
                                  `actions-box` = TRUE, 
                                  # size = 10,
                                  `selected-text-format` = "count > 3"
                                )))),
          "Which team is in possession?", placement = "right")
      })
      outputOptions(output, "team", suspendWhenHidden=FALSE)
      
      
      output$player_shot <- renderUI({
        if(player_shot_init == TRUE){
          choices_shot <- sort(unique(values$data_preprocess$playerLastName))
          selected <- choices_shot
          player_shot_init <<- FALSE
        }
        
        if(length(setdiff(unique(values$data_preprocess$playerLastName), choices_shot) %in% choices_shot) == 0){
          selected <- input$player_shot
        }
        else{
          selected <- c(input$player_shot, setdiff(unique(values$data_preprocess$playerLastName), choices_shot))
        }
        
        
        choices_shot <<- sort(unique(values$data_preprocess$playerLastName))
        
        tipify(fluidRow(
          column(3, tags$label("Shooters")),
          column(9, pickerInput('player_shot',
                                multiple = TRUE,
                                choices = as.character(choices_shot),
                                selected = as.character(selected),
                                options = list(
                                  `actions-box` = TRUE, 
                                  # size = 10,
                                  `selected-text-format` = "count > 3"
                                ))
                 )),
          "Which players made the shot?", placement = "right")
      })
      
      outputOptions(output, "player_shot", suspendWhenHidden=FALSE)
      
      
      
      output$time_range1 <- renderUI({
        period <- values$data_preprocess$period
        min <- 0
        max <- 20
        if(is.null(input$time_range1)){
          selected_min <- 0
          selected_max <- 20
        }
        else{
          selected_min <- input$time_range1[1]
          selected_max <- input$time_range1[2]
        }
        if('1' %in% period){
          tipify(sliderInput("time_range1",
                             "First Period:",
                             min = min,
                             max = max,
                             value = c(selected_min,selected_max)),
                 "Time interval")
        }
      })
      outputOptions(output, "time_range1", suspendWhenHidden=FALSE)
      
      output$time_range2 <- renderUI({
        period <- values$data_preprocess$period
        min <- 20
        max <- 40
        if(is.null(input$time_range2)){
          selected_min <- 20
          selected_max <- 40
        }
        else{
          selected_min <- input$time_range2[1]
          selected_max <- input$time_range2[2]
        }
        if('2' %in% period){
          tipify(sliderInput("time_range2",
                             "Second Period:",
                             min = min,
                             max = max,
                             value = c(selected_min,selected_max)),
                 "Time interval")
        }
      })
      outputOptions(output, "time_range2", suspendWhenHidden=FALSE)
      
      
      output$time_range3 <- renderUI({
        period <- values$data_preprocess$period
        min <- 40
        max <- 60
        if(is.null(input$time_range3)){
          selected_min <- 40
          selected_max <- 60
        }
        else{
          selected_min <- input$time_range3[1]
          selected_max <- input$time_range3[2]
        }    
        if('3' %in% period){
          tipify(sliderInput("time_range3",
                             "Third Period:",
                             min = min,
                             max = max,
                             value = c(selected_min,selected_max)),
                 "Time interval")
        }
      })
      outputOptions(output, "time_range3", suspendWhenHidden=FALSE)
      
      
      output$time_range4 <- renderUI({
        period <- values$data_preprocess$period
        min <- 60
        max <- max_time
        if(is.null(input$time_range4)){
          selected_min <- 60
          selected_max <- max_time
        }
        else{
          selected_min <- input$time_range4[1]
          selected_max <- input$time_range4[2]
        }
        if('4' %in% period){
          tipify(sliderInput("time_range4",
                             "Over Time:",
                             min = min,
                             max = max,
                             value = c(selected_min,selected_max)),
                 "Time interval")
        }
      })
      outputOptions(output, "time_range4", suspendWhenHidden=FALSE)
      
      
      output$player_position <- renderUI({
        if(player_position_init == TRUE){
          choices_position <- unique(values$data_preprocess$playerPosition)
          selected <- choices_position
          player_position_init <<- FALSE
        }
        
        
        if(length(setdiff(unique(values$data_preprocess$playerPosition), choices_position) %in% choices_position) == 0){
          selected <- input$player_position
        }
        else{
          selected <- c(input$player_position, setdiff(unique(values$data_preprocess$playerPosition), choices_position))
        }
        
        choices_position <<- unique(values$data_preprocess$playerPosition)
        
        
        #   else {selected <- c(input$checkbox, setdiff(choices, unique(values$data_preprocess$numPlayers)))}
        tipify(fluidRow(
          column(3, tags$label("Shooter's role")),
          column(9, pickerInput('player_position', label = NULL,
                                multiple = TRUE,
                                choices = as.character(choices_position), 
                                selected = as.character(selected),
                                options = list(
                                  `actions-box` = TRUE, 
                                  # size = 10,
                                  `selected-text-format` = "count > 3"
                                ))
                 )),
          "Choose the role of the shooter", placement = "right")
        
      })
      outputOptions(output, "player_position", suspendWhenHidden=FALSE)
      
      observe({
        invalidateLater(1500, session)
        isolate(values$time_range1 <- input$time_range1)
        isolate(values$time_range2 <- input$time_range2)
        isolate(values$time_range3 <- input$time_range3)
        isolate(values$time_range4 <- input$time_range4)
      })
      
      
      ##-------------------------PREPROCES FILE 2------------------------------------
      
      preprocess_file_2 <- reactive( {
        
        numPlayers <- input$checkbox
        playerName <- input$player_shot
        goalieName <- input$goalie
        time_range1 <- values$time_range1
        time_range2 <- values$time_range2
        time_range3 <- values$time_range3
        time_range4 <- values$time_range4
        player_position <- input$player_position
        team <- input$team
        player_ref <- input$player_ref
        Match <- input$matches_selection
        
        period <- input$period
        outcome <- input$layers
        powerplays <- input$layers_manpower
        zone <- input$zone
        blocked <- input$blocked
        deflected <- input$deflected
        
        
        
        values$data_preprocess2 <- 
          preprocess_file_2_fun(values$data, type = 1, numPlayers, playerName, 
                                goalieName, time_range1, time_range2, time_range3, 
                                time_range4, player_position, team, player_ref, 
                                Match, period, outcome, powerplays, zone, 
                                blocked, deflected)
   
           })
      
      
      
      ########################################## RESET BUTTON ##############################################3
      observeEvent(input$reset, {
        updateSliderInput(session, "binNumber", 
                          min = 3, 
                          max = 10, 
                          value = 5,
                          step = 1
        )
        updatePickerInput(session, 'matches_selection',
                          choices = as.character(unique(values$data$Match)),
                          selected = as.character(unique(values$data$Match))
        )
        updatePickerInput(session, 'team',
                          choices = as.character(unique(values$data$teamInPossession)),
                          selected = as.character(unique(values$data$teamInPossession))
        )
        updateCheckboxGroupInput(session, "period", label = PERIOD_TAG,
                                 choices = unique(values$data$period),
                                 selected = unique(values$data$period),
                                 inline = T)
        updateSliderInput(session, "time_range4",
                          "Over Time:",
                          min = 60,
                          max = max_time,
                          value = c(60,max_time))
        updateSliderInput(session, "time_range3",
                          "Third Period:",
                          min = 40,
                          max = 60,
                          value = c(40,60))
        updateSliderInput(session, "time_range2",
                          "Second Period:",
                          min = 20,
                          max = 40,
                          value = c(20,40))
        updateSliderInput(session, "time_range1",
                          "First Period:",
                          min = 0,
                          max = 20,
                          value = c(0,20))
        updatePickerInput(session, 'layers', label = LAYERS, 
                          choices = as.character(unique(values$data$outcome)), 
                          selected = as.character(unique(values$data$outcome))
        )
        updatePickerInput(session, 'zone', label = ZONE_TAG, 
                          choices = c("outside" = "outside", "slot" = "slot"), 
                          selected = c("outside", "slot")
        )
        updatePickerInput(session, 'blocked', label = BLOCKED_TAG, 
                          choices = c("blocked" = "1", "unblocked" = "0"), 
                          selected = c("0", "1")
        )
        updatePickerInput(session, 'deflected', label = DEFLECTED_TAG, 
                          choices = c("deflected" = "1", "straight" = "0"), 
                          selected = c("1", "0")
        )
        updatePickerInput(session, 'player_position', label = 'player type', 
                          choices = as.character(unique(values$data$playerPosition)), 
                          selected = as.character(unique(values$data$playerPosition))
        )
        updatePickerInput(session, 'layers_manpower', label = LAYERS_MANPOWER, 
                          choices = as.character(unique(values$data$manpowerSituation)), 
                          selected = as.character(unique(values$data$manpowerSituation))
        )
        
        updateCheckboxGroupInput(session, inputId = "checkbox",label = "Players on ice", choices = unique(values$data$numPlayers),
                                 selected = unique(values$data$numPlayers), inline = T)
        
        updatePickerInput(session, 'player_shot', label = "Shooters", 
                          choices = as.character(sort(unique(values$data$playerLastName))),
                          selected = as.character(sort(unique(values$data$playerLastName)))
        )
        
        updatePickerInput(session, 'goalie',
                          label = NULL,
                          choices = as.character(sort(unique(values$data$goalieLastName))),
                          selected = as.character(sort(unique(values$data$goalieLastName)))
        )
        
        # choices_ref <- unique(values$data_preprocess$playerReferenceId)
        # selected <- choices_ref
        # 
        # 
        # player_name <- as.character(choices_ref)
        # player_surname <- as.character(choices_ref)
        # for(i in (1:length(choices_ref))){
        #   
        #   if(length(players[which(choices_ref[i] == players[,1]),2]) > 0){
        #     player_name[i] <- players[which(choices_ref[i] == players[,1]),2]
        #     player_surname[i] <- players[which(choices_ref[i] == players[,1]),3]
        #   }
        # }
        # name <- paste0(player_name, ' ', player_surname )
        # 
        # names(choices_ref) <- name
        # 
        
        updatePickerInput(session, 'player_ref',
                          choices = choices_ref,
                          selected = NULL
        )
        
        
        init <<- TRUE
      })
      
      ##-------------------------PREPROCES FILE 2 ALL SEASON------------------------------------
      
      preprocess_file_2_season <- reactive( {
        if (input$type == "extended") {
          numPlayers <- input$checkbox
          playerName <- input$player_shot
          goalieName <- input$goalie
          time_range1 <- input$time_range1
          time_range2 <- input$time_range2
          time_range3 <- input$time_range3
          time_range4 <- input$time_range4
          player_position <- input$player_position
          team <- input$team
          player_ref <- input$player_ref
          Match <- input$matches_selection
          
          period <- input$period
          outcome <- input$layers
          powerplays <- input$layers_manpower
          zone <- input$zone
          blocked <- input$blocked
          deflected <- input$deflected
          
          
          
          
          values$data_preprocess2_season <- preprocess_file_2_fun(values$data_preprocess_season, type=2,numPlayers, playerName, goalieName, time_range1, time_range2, time_range3, time_range4, player_position, team, player_ref, Match, period, outcome, powerplays, zone, blocked, deflected)
        }
      })
      
      
      ##-------------------------GET DENSITY------------------------------------
      
      get_density <- reactive({
        if (input$type == "continous"){
          
          
          nlevels <- input$binNumber
          game_shots <- values$data_preprocess2
          
          dens <- MASS::kde2d(c(game_shots$xAdjCoord, -100,0,0,100),
                              c(game_shots$yAdjCoord, 50,-100,200,500),
                              h = bandwidth, 
                              n = smoothness)
          
          return(contourLines(x = dens$x, y = dens$y, z = dens$z, nlevels = nlevels))
        } 
      })
    
      
      ##-------------------------GET COLOURS------------------------------------
      
      get_colours <- function(level_list){
        
        
        n <- length(level_list)
        palette <- colorRampPalette(den_color)(n)
        names(palette) <- level_list
        
        return(palette)
      }
      
      
      ##-------------------------GET CONTOUR SHAPES------------------------------------
      
      get_contour_shapes <- function(m, data){
        
        # Range for layout
        if(max(data$xAdjCoord)>50) {
          range_x <- c(-0.1,100.1)
          range_y <- c(-42.6, 42.6)
        }
        else {
          range_y <- c(-0.1,100.1)
          range_x <- c(-42.6, 42.6)
        }
        
        cl <- get_density()
        max_cl <- length(cl)
        unique_densities <- unique(unlist(lapply(cl, function(x){x$level})))
        cl_levels <- as.character(unique_densities)
        colours <- get_colours(cl_levels)
        dim <- length(cl_levels)
        cl_in_leg <- 1:dim
        
        # Add index to the list
        for(i in 1:max_cl) {
          cl[[i]]$index <- i
        }
        
        # Who is a hole of other contours?
        holes <- as.data.frame(do.call(rbind, lapply(cl, function(elem) 
          matrix(c(elem$level, min(elem$x), max(elem$x), min(elem$y), max(elem$y)), 
                 1, 5)
        )))
        holes$hole <- NA
        holes$index <- 1:nrow(holes)
        
        for(lev in unique_densities) {
          temp_df <- holes[holes$V1==lev,]
          for(i in 1:(nrow(temp_df))) {
            is_hole <- as.numeric(any(temp_df$V2[i]>temp_df$V2 &
                                        temp_df$V3[i]<temp_df$V3 &
                                        temp_df$V4[i]>temp_df$V4 &
                                        temp_df$V5[i]<temp_df$V5))
            holes$hole[temp_df$index[i]] <- is_hole
          }
        }
        
        # Double check
        
        index_holes <- holes$index[holes$hole==1]
        cl_holes <- cl[index_holes]
        unique_densities_holes <- unique(unlist(lapply(cl_holes, function(x){x$level})))
        for(lev in unique_densities_holes) {
          cl_level_hole <- cl[holes$index[holes$V1==lev]]
          index_hole_in_selection <- 
            which(unlist(lapply(cl_holes, function(x){x$level}))==lev)
          index_hole_in_selection <- 
            unlist(lapply(cl_holes[index_hole_in_selection], function(x) {x$index}))
          for(i in index_hole_in_selection) {
            ind_current <- which(unlist(lapply(cl_level_hole, function(x){x$index}))==i)
            target_cl <- cl_level_hole[[ind_current]]
            cl_temp <- cl_level_hole[-ind_current]
            actual_hole <- F
            j <- 1
            while(!actual_hole & j<length(cl_temp)) {
              if(sum(point.in.polygon(target_cl$x, target_cl$y,
                                      cl_temp[[j]]$x, cl_temp[[j]]$y) > 0)) {
                holes$hole[i] <- 1
                actual_hole <- T
              }
              j <- j+1
            }
            if(!actual_hole)
              holes$hole[i] <- 0
          }
        }
        
        poly <- holes$index[holes$hole==0]
        holes <- rev(holes$index[holes$hole==1])
        
        for(i in poly){	
          col_legend <- paste(round(which(cl_levels==cl[[i]][1])/dim*100, 2), "%")
          showlegend <- which(cl_levels==cl[[i]][1]) %in% cl_in_leg
          if(any(cl_in_leg %in% which(cl_levels==cl[[i]][1])))
            cl_in_leg <- cl_in_leg[-which(cl_in_leg==which(cl_levels==cl[[i]][1]))]
          m <- add_polygons(m, cl[[i]]$x,cl[[i]]$y,
                            line=list(width=line_width,color=line_color),
                            opacity = opacity,
                            fillcolor = colours[[as.character(cl[[i]]$level)]],
                            color = colours[[as.character(cl[[i]]$level)]],
                            text = paste("Percentage of shots:", col_legend),
                            hoverinfo = 'text',
                            name = col_legend,
                            legendgroup = col_legend,
                            showlegend = showlegend) %>%
            layout(xaxis = list(range = range_x),
                   yaxis = list(range = range_y))
        }
        
        levels_holes <- c("-1", cl_levels)
        for(i in holes){	
          if(levels_holes[which(cl_levels==cl[[i]][1])]=="-1") {
            m <- add_polygons(m, cl[[i]]$x,cl[[i]]$y,
                              line=list(width=line_width,color=line_color),
                              opacity = opacity,
                              fillcolor = "#f4f4f4",
                              hoverinfo = 'none',
                              showlegend = F) %>%
              layout(xaxis = list(range = range_x),
                     yaxis = list(range = range_y))
          }
          else {
            col_legend <- paste(round((which(cl_levels==cl[[i]][1])-1)/dim*100, 2), "%")
            index_col <- levels_holes[which(cl_levels==as.character(cl[[i]]$level))]
            m <- add_polygons(m, cl[[i]]$x,cl[[i]]$y,
                              line=list(width=line_width,color=line_color),
                              opacity = opacity,
                              fillcolor = colours[[index_col]],
                              color = colours[[as.character(cl[[i]]$level)]],
                              text = paste("Percentage of shots:", col_legend),
                              hoverinfo = 'text',
                              name = col_legend,
                              showlegend = F) %>%
              layout(xaxis = list(range = range_x),
                     yaxis = list(range = range_y))
          }
          
        }
        
        return(m)
      }
      
      ##-------------------------Choose layout--------------------------------
      
      
      shapes <- reactive({
        if(orientation$Orientation == 'Vertical'){}
        if(input$add_angles[1] %% 2 == 1){print(input$add_angles[1])}
        if(input$add_angles[1] %% 2 == 1){
          if(orientation$Orientation == 'Vertical'){
            lay <- list.append(rink_shapes,list(type = 'line',
                                                x0 = 0, y0 = 89, x1 = 42.5, y1 = 80.9,
                                                line = list(color = 'rgba(0,0,0,0.6)')))
            lay <- list.append(lay,list(type = 'line',
                                        x0 = 0, y0 = 89, x1 = 42.5, y1 = 54,
                                        line = list(color = 'rgba(0,0,0,0.6)')))
            lay <- list.append(lay,list(type = 'line',
                                        x0 = 0, y0 = 89, x1 = 42.5, y1 = 25.5,
                                        line = list(color = 'rgba(0,0,0,0.6)')))
            lay <- list.append(lay,list(type = 'line',
                                        x0 = 0, y0 = 89, x1 = 0, y1 = 25.5,
                                        line = list(color = 'rgba(0,0,0,0.6)')))
            lay <- list.append(lay,list(type = 'line',
                                        x0 = 0, y0 = 89, x1 = -42.5, y1 = 80.9,
                                        line = list(color = 'rgba(0,0,0,0.6)')))
            lay <- list.append(lay,list(type = 'line',
                                        x0 = 0, y0 = 89, x1 = -42.5, y1 = 54,
                                        line = list(color = 'rgba(0,0,0,0.6)')))
            lay <- list.append(lay,list(type = 'line',
                                        x0 = 0, y0 = 89, x1 = -42.5, y1 = 25.5,
                                        line = list(color = 'rgba(0,0,0,0.6)')))
          }
          
          
          else{
            lay <- list.append(rink_shapes,list(type = 'line',
                                                y0 = 0, x0 = 89, y1 = 42.5, x1 = 80.9,
                                                line = list(color = 'rgba(0,0,0,0.6)')))
            lay <- list.append(lay,list(type = 'line',
                                        y0 = 0, x0 = 89, y1 = 42.5, x1 = 54,
                                        line = list(color = 'rgba(0,0,0,0.6)')))
            lay <- list.append(lay,list(type = 'line',
                                        y0 = 0, x0 = 89, y1 = 42.5, x1 = 25.5,
                                        line = list(color = 'rgba(0,0,0,0.6)')))
            lay <- list.append(lay,list(type = 'line',
                                        y0 = 0, x0 = 89, y1 = 0, x1 = 25.5,
                                        line = list(color = 'rgba(0,0,0,0.6)')))
            lay <- list.append(lay,list(type = 'line',
                                        y0 = 0, x0 = 89, y1 = -42.5, x1 = 80.9,
                                        line = list(color = 'rgba(0,0,0,0.6)')))
            lay <- list.append(lay,list(type = 'line',
                                        y0 = 0, x0 = 89, y1 = -42.5, x1 = 54,
                                        line = list(color = 'rgba(0,0,0,0.6)')))
            lay <- list.append(lay,list(type = 'line',
                                        y0 = 0, x0 = 89, y1 = -42.5, x1 = 25.5,
                                        line = list(color = 'rgba(0,0,0,0.6)')))
          }
          values$layout <- lay
        }
        else{
          values$layout <- rink_shapes
        }
      })
      
      ##-------------------------PLOT RINK------------------------------------
      
      
      plot_rink <- function(data, shapes){
        if(length(data[,1]) > 0){
          
          # Create data of only goals, successful and failed hits
          data_goal <- data[data$outcome=="goal",]
          data_successful <- data[data$outcome=="successful",]
          data_failed <- data[data$outcome=="failed",]
          
          p1 <- plot_ly(data = data, x = ~xAdjCoord, y = ~yAdjCoord) %>%
            get_contour_shapes(data)
          
          if(length(data_goal[,1]) > 0) {
            p1 <- p1 %>% 
              add_trace(data = data_goal, x = ~xAdjCoord, y = ~yAdjCoord, 
                        type = "scatter", mode = 'markers',
                        text = ~hover_info, hoverinfo="text",
                        name = "goal", opacity = 0.8,
                        marker = list(color = "#eb1010", sizeref=0.7, sizemode="area",
                                      line = list(color='black', width = 1)))
          }
          
          if(length(data_successful[,1]) > 0) {
            p1 <- p1 %>% 
              add_trace(data = data_successful, x = ~xAdjCoord, y = ~yAdjCoord, 
                        type = "scatter", mode = 'markers',
                        text = ~hover_info, hoverinfo="text",
                        name = "successful", opacity = 0.8,
                        marker = list(color = "#10EA10", sizeref=0.7, sizemode="area",
                                      line = list(color='black', width = 1)))
          }
          
          if(length(data_failed[,1]) > 0) {
            p1 <- p1 %>% 
              add_trace(data = data_failed, x = ~xAdjCoord, y = ~yAdjCoord, 
                        type = "scatter", mode = 'markers',
                        text = ~hover_info, hoverinfo="text",
                        name = "failed", opacity = 0.8,
                        marker = list(color = "#1010EA", sizeref=0.7, sizemode="area",
                                      line = list(color='black', width = 1)))
          }
          
          p1 <- p1 %>%
            layout(shapes = shapes, showlegend = T, plot_bgcolor = "#f4f4f4", 
                   paper_bgcolor = "#f4f4f4", 
                   xaxis = list(title = list(text ="")),
                   yaxis = list(title = list(text = ""), #visible=F),
                                scaleanchor = "x", scaleratio = 0.9)) #visible=F),
        }
        else {
          p1 <- base_plot
        }
        
        return(p1)
      }
      
    
      
      ##-------------------------CHOOSE DATA------------------------        
      choose_plot <- reactive({
        print('inside choose plot')
        preprocess_file()
        preprocess_file_2()
        
        type <- input$type
          if (type == "extended"){
            preprocess_file_season()
            preprocess_file_2_season()
            return(get_discrete_plot_vs_average(values$data_preprocess2, values$data_preprocess2_season, orientation$Orientation))
          }
          if (type == "continous"){
            print('inside continous')
            shapes()
            return(plot_rink(values$data_preprocess2, values$layout))
            }
          if (type == "discrete"){
         #   data <- preprocess_file_2()
            return(get_discrete_plot(values$data_preprocess2, orientation$Orientation))
          }
        
      }) 
      
    
      output$rink <- renderPlotly({
        choose_plot()
      })
        
    }
  })
  
}

shinyApp(ui = ui, server = server)