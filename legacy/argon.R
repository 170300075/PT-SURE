if(interactive()){
  library(shiny)
  library(argonDash)
  
  shiny::shinyApp(
    ui = argonDashPage(),
    server = function(input, output) {}
  )
}

