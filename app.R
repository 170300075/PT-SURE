library(shiny)
library(bslib)
library(bs4Dash)
library(toastui)
library(DiagrammeR)

# our custom components
source("matriculaInput.R")
source("contraseñaInput.R")
# placeholder personal data (only development)
source("userdata.R")

login <- div(
  #theme = bs_theme(version = 5),
  #tags$head(
  #  tags$script(src = "showPassword.js"),
  #),
  
  div(
    class = "bg-dark bg-gradient",
    div(
      class = "container",
      div(
        class = "row vh-100 align-items-center justify-content-center",
        div(
          class = "col-7",
          div(
            class = "card border-0 shadow-lg",
            div(
              class = "row g-0",
              div(
                class = "col-md-5",
                img(
                  class = "img-fluid rounded-start",
                  src = "images/assets/entrada.jpeg"
                )
              ),
              
              div(
                class = "col-md-7",
                div(
                  class = "card-body",
                  h5(
                    class = "card-title text-center mt-3 display-6", # nolint
                    "Iniciar sesión"
                  ),
                  
                  tags$div(
                    class = "col-10 mx-auto mt-4",
                    
                    matriculaInput(inputId = "id_user", label = "Tu matricula"),
                  
                    contraseñaInput(inputId = "password", label = "Contraseña"),
                    
                    div(
                      class = "form-check mb-4",
                      tags$input(
                        type = "checkbox",
                        class = "form-check-input",
                        id = "exampleCheck1",
                        "onclick"="showPassword()",
                        tags$label(
                          class = "form-check-label user-select-none",
                          `for` = "exampleCheck1",
                          "Mostrar contraseña"
                        )
                      )
                    ),
                    
                    actionButton(
                      inputId = "acceder",
                      label = "Acceder",
                      class = "btn-primary"
                    ),
                    
                    textOutput(
                      outputId = "user_id"
                    )
                  )
                ),
                
                p(
                  class = "card-text text-center mt-2",
                  tags$small(
                    class = "text-muted",
                    "Universidad del Caribe"
                  )
                )
              )
            )
          )
        )
      )
    )
  )
)

dashboard <- dashboardPage(
  # The Dashboard Header
  dashboardHeader(
    status = "dark",
    border = TRUE, 
    fixed = TRUE,

    # output user logout (right navbar side)
    rightUi = userOutput("user"),

    # output notifications (left navbar side)
    leftUi = tagList(
      dropdownMenuOutput(outputId = "messageMenu"),
      dropdownMenuOutput(outputId = "notificationMenu"),
      dropdownMenuOutput(outputId = "taskMenu")
    ) 
  ),

  # The Dashboard Sidebar
  dashboardSidebar(
    skin = "dark",
    status = "lime",
    elevation = "3",
    collapsed = FALSE,
    expandOnHover = TRUE,

    uiOutput(outputId = "user_panel"),

    # sidebar career menu
    sidebarMenu(
      id = "career_menu",
      sidebarHeader("Carrera"),

      # personal progress tab
      menuItem(
        text = "Progreso personal",
        tabName = "progress",
        icon = icon("tachometer-alt")
      ),

      # personal KPI tab
      menuItem(
        text = "Estadísticas",
        tabName = "performance",
        icon = icon("chart-pie")
      ),

      # educational investment tab
      menuItem(
        text = "Balance",
        tabName = "investment",
        icon = icon("exchange-alt")
      )
    ),

    # sidebar subjects menu
    sidebarMenu(
      id = "subjects_menu",
      sidebarHeader("Asignatura"),

      # scholar chedule
      menuItem(
        text = "Mi Horario",
        tabName = "schedule",
        icon = icon("calendar-check")
      ),

      # academic offer
      menuItem(
        text = "Asignaturas",
        tabName = "subjects",
        icon = icon("clipboard-list")
      ),

      # practices offer
      menuItem(
        text = "Prácticas",
        tabName = "practices",
        icon = icon("briefcase")
      ),

      # service offer
      menuItem(
        text = "Servicio",
        tabName = "service",
        icon = icon("user-friends")
      )
    ),

    sidebarMenu(
      id = "booking",
      sidebarHeader("Eventos"),

      # school calendar
      menuItem(
        text = "Calendario escolar",
        tabName = "calendar",
        icon = icon("calendar-day")
      ),

      # teaching performance
      menuItem(
        text = "Desempeño docente",
        tabName = "educators",
        icon = icon("book-reader")
      )
    ),

    sidebarMenu(
      id = "settings",
      sidebarHeader("Información"),

      # personal data
      menuItem(
        text = "Mi cuenta",
        tabName = "config",
        icon = icon("cogs")
      )
    )
  ),

  # The Dashboard Body
  dashboardBody(
    div(
      class = "",
      tabItems(
        # personal progress tabitem
        tabItem(
          tabName = "progress",

          h1("Mapa Curricular", class = "m-4 mb-5 text-center"),

          # output curricular map
          grVizOutput("map")
        ),

        # personal KPI tabitem
        tabItem(
          tabName = "performance",

          h1("Estadísticas generales", class = "m-4 mb-5 text-center"),
          fluidRow(
            # infobox outputs
            infoBoxOutput(outputId = "first_cycle", width = 3),
            infoBoxOutput(outputId = "second_cycle", width = 3),
            infoBoxOutput(outputId = "third_cycle", width = 3),
            infoBoxOutput(outputId = "fourth_cycle", width = 3)
          )
        ),

        # educational investment tabitem
        tabItem(
          tabName = "investment",

          h1("Pagos y adeudos", class = "m-4 mb-5 text-center"),
          datagridOutput(outputId = "payments")
        ),

        # scholar chedule tabitem
        tabItem(
          tabName = "schedule",

          h1("Horario y calificaciones", class = "m-4 mb-5 text-center")
        ),

        # academic offer tabitem
        tabItem(
          tabName = "subjects",

          h1("Lista de asignaturas", class = "m-4 mb-5 text-center")
        ),

        # practices offer tabitem
        tabItem(
          tabName = "practices",

          h1("Lista de prácticas", class = "m-4 mb-5 text-center")
        ),

        # service offer tabitem
        tabItem(
          tabName = "service",

          h1("Lista de servicio social", class = "m-4 mb-5 text-center")
        ),

        # school calendar tabitem
        tabItem(
          tabName = "calendar",
          h1(
            paste0("Calendario ", format(Sys.Date(), "%Y")), 
            class = "m-4 mb-0 text-center"
          ),
          calendarOutput(
            outputId = "school_calendar", 
            width = "100%",
            height = "600px" 
          )
        ),

        # teaching performance tabitem
        tabItem(
          tabName = "educators",

          h1("Evaluación al desempeño docente", class = "m-4 mb-5 text-center")
        ),

        # personal data tabitem
        tabItem(
          tabName = "config",

          h1("Ajustes de la cuenta", class = "m-4 mb-5 text-center")
        )
      )
    )
  ),

  # The Dashboard Footer
  dashboardFooter(
    left = HTML("<p class='text-muted m-0'><b>Sistema Unificado de Recomendación Escolar</b> &copy; Universidad del Caribe</p>"), 
    right = HTML("<p>Made with <i class='fas fa-heart text-danger'></i> by <b>Kenneth</b></p>"), 
    fixed = FALSE
  ),

  # The Dashboard Controlbar
  controlbar = dashboardControlbar(
    id = "controlbar",
    skin = "dark",
    collapsed = TRUE,
    overlay = TRUE,
    div(
      class = "p-4",
      skinSelector()
    )
  )
)

ui <- div(
  theme = bs_theme(version = 5),
  tags$head(
    tags$link(rel="stylesheet", href = "hiddenScrollbar.css"),
    tags$script(src = "showPassword.js")
  ),
  # wrapper container for login
  div(id = "login_container"),

  # wrapper container for dashboard
  div(id = "dashboard_container")
)

server <- function(input, output, session) {
  # initially we insert the login form
  insertUI(
    selector = "#login_container",
    where = "afterBegin",
    ui = login
  )

  # if button is form button is pressed
  observeEvent(input$acceder, {
    # then remove the current login container
    removeUI(
      selector = "#login_container"
    )

    # verify if credentials are correct
    if(input$id_user == 170300075){
      # if does, insert the bashboard in the page
      insertUI(
        selector = "#dashboard_container",
        where = "afterBegin",
        ui = dashboard
      )

    }

    # if credentials are incorrect
    else {
      # insert the login form container again (because it was deleted before)
      insertUI(
        selector = "#dashboard_container",
        where = "beforeBegin",
        ui = div(id = "login_container")
      )

      # insert the login form in the login container
      insertUI(
        selector = "#login_container",
        where = "afterBegin",
        ui = login
      )
    }
  })


  #######################################################
  #           Update and mount all the outputs          #
  #######################################################
  
  # render user logout
  output$user <- renderUser({
    # adding the user specific data
    dashboardUser(
      name = username,
      image = profile_picture,
      title = career,
      subtitle = department,
      status = "navy",
      footer = fluidRow(
        dashboardUserItem(
          width = 12,
          actionButton(
            inputId = "logout_button",
            label = "Cerrar sesión",
            icon = icon("sign-out-alt"),
            width = "80%",
            status = "primary",
            outline = TRUE,
            size = "sm"
          )
        )
      )
    )
  })

  # dropdown message menu (left navbar side)
  output$messageMenu <- renderMenu({
    messages <- apply(messageData, 1, function(row) {
      messageItem(
        from = row[["from"]],
        message = row[["message"]],
        icon = icon(row[["icon"]]),
        time = row[["time"]],
        href = row[["href"]],
        image = row[["image"]],
        color = row[["color"]],
        inputId = row[["inputId"]]
      )
    })

    dropdownMenu(type = "messages", .list = messages)
  })

  # dropdown notification menu (left navbar side)
  output$notificationMenu <- renderMenu({
    notifications <- apply(notificationData, 1, function(row) {
      notificationItem(
        text = row[["text"]],
        icon = icon(row[["icon"]]),
        status = row[["status"]],
        href = row[["href"]],
        inputId = row[["inputId"]]
      )
  })
   
    dropdownMenu(type = "notifications", .list = notifications)
  })

  # dropdown task menu (left navbar side)
  output$taskMenu <- renderMenu({
    tasks <- apply(taskData, 1, function(row) {
      taskItem(
        text = row[["text"]],
        value = row[["value"]],
        color = row[["color"]],
        href = row[["href"]],
        inputId = row[["inputId"]]
      )
    })

    dropdownMenu(type = "task", .list = tasks)
  })



  # render infoboxes
  output$first_cycle <- renderInfoBox({
    infoBox(
      title = h5("Primer ciclo"),
      value = "Créditos: 100/100",
      subtitle = em("Concluido"),
      icon = icon("check-circle"),
      color = "lime",
      elevation = 2,
      iconElevation = 2
    )
  })

  output$second_cycle <- renderInfoBox({
    infoBox(
      title = h5("Segundo ciclo"),
      value = "Créditos: 80/100",
      subtitle = em("En progreso"),
      icon = icon("circle-notch"),
      color = "info",
      elevation = 2,
      iconElevation = 2
    )
  })

  output$third_cycle <- renderInfoBox({
    infoBox(
      title = h5("Tercer ciclo"),
      value = "Créditos: 60/80",
      subtitle = em("Reprobadas: 1", class = "text-danger"),
      icon = icon("exclamation-circle"),
      color = "danger",
      elevation = 2,
      iconElevation = 2
    )
  })

  output$fourth_cycle <- renderInfoBox({
    infoBox(
      title = h5("Cuarto ciclo"),
      value = "Créditos: 0/150",
      subtitle = em("Sin comenzar", class = "text-muted"),
      icon = icon("pause-circle"),
      color = "gray-dark",
      elevation = 2,
      iconElevation = 2
    )
  })



  # render calendar
  output$school_calendar <- renderCalendar({
    calendar(cal_demo_data(), navigation = TRUE)
  })

  # logout button
  observeEvent(input$logout_button, {
    # if logout button is pressed
    # then, reload the session
    session$reload()
  })

  # render sidebar user panel
  output$user_panel <- renderUI({
    sidebarUserPanel(
      name = username,
      image = profile_picture
    )
  })

  # render curricular map
  output$map <- renderGrViz({
    grViz("
      digraph dot {
        graph [layout = dot]
        
        node [shape = square,
              style = rectangle,
              color = grey,
              label = '']
        
        node [fillcolor = red]
        a b c d e
        
        node [fillcolor = green]
        f g h i j
        
        node [fillcolor = orange]
        
        edge [color = grey, 
              arrowhead = tee]
              
        a -> {f}
        b -> {g}
        c -> {h}
        d -> {i}
        e -> {j}
        
        f -> {k}
        g -> {l}
        h -> {m}
        i -> {n}
        j -> {o}
      }
    ")
  })
  
  # render payments
  output$payments <- renderDatagrid({
    datagrid(payments)
  })
}

options(shiny.port = 4000)
shinyApp(ui, server)
