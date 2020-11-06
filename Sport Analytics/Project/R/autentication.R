Logged = FALSE
my_username <- "test"
my_password <- "test"

ui_autentication <- function(){
  fluidPage(
    column(3, br()),
    column(6,
           h4(em("ShinyApps can be encripted in various ways. The easiest method
                  is to provide a log in screen, included here as a demonstration."),
              style = "color:#dcddcd; font-size:16pt", align = "center"),
           br(),
           h4("The username and the password in this case are simply",
              strong("test"), "and", strong("test"), "(no capital letters!).",
              style = "color:#dcddcd; font-size:16pt", align = "center"),
           br(),
           br(),
           tagList(
             div(id = "login",
                 HTML('<h2 style="color:#dcddcd">Sign In</h2>'),
                 wellPanel(textInput("userName", "Username"),
                           passwordInput("passwd", "Password"),
                           br(),actionButton("Login", "Log in"))),
             tags$style(type="text/css", "#login {font-size:10px;
               text-align: left;
               top: 40%; left: 50%, max-width: 100px}")
           )),
    column(3, br())
  )}