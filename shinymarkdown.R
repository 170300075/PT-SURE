if(interactive()) {
  
  library(shiny)
  library(shinymarkdown)
  ui <- fluidPage(
    mdInput(inputId = "myEditor", height = "500px", hide_mode_switch = F)
  )
  
  server <- function(input, output, session) {
    
    # Hide the editor
    observeEvent(input$hide, {hide_editor(.id = "myEditor")})
    
    # Show the editor
    observeEvent(input$show, {show_editor(.id = "myEditor")})
    
  }
  
  shinyApp(ui, server)
  
}
