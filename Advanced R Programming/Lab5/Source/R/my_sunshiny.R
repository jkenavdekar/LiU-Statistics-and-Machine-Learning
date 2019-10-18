library(dplyr)
#' Title my_sunshine
#'
#' @field server_components list. It contains ui and server for the Shiny application.
#' @description This class uses another class in order to have access in an API.
#' It is also create a Shiny application for air pollution.
#' @import dplyr
#' @import methods
#' @export My_shiny
#' @exportClass My_shiny
My_shiny<-
  setRefClass(
  "My_shiny",
  fields = list(
    server_components="list"
  ),
  methods=list(
    initialize=function(){
      countries = list(
        "Turkey",
        "Italy",
        "Greece",
        "Sweden"
      )
      server_components<<-list()
      apii <- MyShiny::Worldwide_Pollution$new(countries)
      server_components$ui <<- 
        shiny::navbarPage("Air Pollution",
           shiny::tabPanel("Component 1",
                    shiny::plotOutput("plot_1")),
           
           shiny::tabPanel("Component 2",
                    shiny::fluidPage(
                      
                      shiny::titlePanel("Concentration of PM25"),
                      
                      shiny::fluidRow(
                        shiny::column(2,
                               shiny::radioButtons(inputId = "radio", 
                                            label = "Select the country you wish to visualize:", 
                                            choices = c("Turkey", "Italy", "Greece", "Sweden"), 
                                            inline = FALSE,
                                            width = NULL)
                        ),
                        shiny::hr(),
                        shiny::column(10, 
                               shiny::fluidRow(plotly::plotlyOutput("plot_2", height = "500px")))))))   
      
      server_components$server<<- function(input, output){
        api = apii
        Sys.setenv(
          'MAPBOX_TOKEN' = 
            'pk.eyJ1Ijoic3RldG84MjAiLCJhIjoiY2ptYm1hNGoxMDVzODNxcDh5YWYwdWIyeiJ9.vqmnBQELpRxT2klgrWJvuQ')
        
        output$plot_1 = shiny::renderPlot({
          facets = c(
            "country",
            "value_pm5"
          )
          plot_pm25_means(api$get_facets_all_responses(facets)) 
        })
        
        output$plot_2 = plotly::renderPlotly({
          facet_vector<-c(
            "country",
            "filename",
            "value_pm5",
            "Category PM25",
            "data_location_latitude",
            "data_location_longitude")
          
          df<-api$get_only_faced_data(api$responses[[input$radio]], facet_vector)
          if(input$radio=="Italy") zoom <- 4.1
          else if(input$radio=="Sweden") zoom <- 3
          else zoom <- 5
          p <- plotly::plot_mapbox(mode = "scattermapbox") %>%
            plotly::add_markers(
              data = df, y = ~data_location_latitude, x = ~data_location_longitude,
              color=~as.factor(`Category PM25`), text = ~filename, hoverinfo = "text",
              hovertext = paste('</br>Category: ', df$`Category PM25`, "</br>Region: ", df$filename,
                                "</br>Value: ", df$value_pm5),
              marker=list(size=10), alpha = 0.5,
              colors = rev(RColorBrewer::brewer.pal(length(unique(df$`Category PM25`)),"PiYG"))) %>%
            plotly::layout(
              plot_bgcolor = '#191A1A', paper_bgcolor = '#191A1A',
              mapbox = list(style = 'dark',
                            scope = "europe",
                            zoom = zoom,
                            center = list(lat = mean(as.numeric(df$data_location_latitude)),
                                          lon = mean(as.numeric(df$data_location_longitude)))),
              legend = list(orientation = 'h',
                            font = list(size = 8)),
              margin = list(l = 0, r = 0,
                            b = 0, t = 0,
                            pad = 0)
            )
          p
          
        })
      }
    },
  run=function(){
    shiny::shinyApp(ui = server_components$ui, server = server_components$server)
  },
  plot_pm25_means=function(all_data){
    mean_table = all_data %>%
      group_by(country) %>%
      summarise(mean=mean(value_pm5))
    g = ggplot2::ggplot(mean_table, ggplot2::aes(x=country, y=mean)) +
      ggplot2::geom_bar(position="dodge", stat="identity") +
      ggplot2::labs(title = "Means of P5 in Countries", x="Countries", y="Mean") +
      ggplot2::scale_y_continuous(breaks=seq(0,70,by=5))
    return(g)
  }
      
  )
)

    