library(shiny)
library(bslib)

# Login Form
loginForm <- function(){
  htmlTemplate("login.html")
}

ui <- fluidPage(
  theme = bs_theme(version = 5),
  h1("Hola mundo"),
  br(), br(),
  loginForm()
  
)

server <- function(input,output,session){}

shinyApp(ui, server)
