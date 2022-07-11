library(shiny)
library(bslib)
library(bs4Dash)
library(shinyWidgets)
library(dplyr)
library(toastui)
library(ggplot2)
library(DiagrammeR)
library(waiter)
# library(shinymarkdown)
library(mapboxer)

useSweetAlert()

# our custom components
source("matriculaInput.R")
source("contraseñaInput.R")
source("sessionData.R")

login <- div(
  div(
    class = "bg-light",
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
    expandOnHover = FALSE,

    # userpanel output
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
        ),
        
        fluidRow(
          column(width = 6,
            # output for speedometer 
            chartOutput(outputId = "speedometer")
          ), 
          
          column(width = 6,
            # school grades by semester
            chartOutput(outputId = "grades")
          )
        )
        
      ),

      # educational investment tabitem
      tabItem(
        tabName = "investment",

        h1("Pagos y adeudos", class = "m-4 mb-5 text-center"),
        fluidRow(
          column(width = 6,
            box(
              title = h4("Tabla de datos"),
              closable = FALSE, 
              solidHeader = TRUE,
              collapsible = FALSE, 
              width = 12,
              status = "navy",
              
              chartOutput(outputId = "payments_chart", height = "500px")
            )
          ),
          
          column(width = 6,
            box(
              title = h4("Histórico"),
              closable = FALSE, 
              solidHeader = TRUE,
              collapsible = FALSE, 
              width = 12,
              status = "navy",
              
              datagridOutput(outputId = "payments", height = "500px")
            )
          )
        )
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

        h1("Evaluación al desempeño docente", class = "m-4 mb-5 text-center"),

        uiOutput(outputId = "teachers_forms")
      ),

      # personal data tabitem
      tabItem(
        tabName = "config",

        h1("Ajustes de la cuenta", class = "m-4 mb-5 text-center"),

        uiOutput(outputId = "user_information"),

        # mdInput(
        #   inputId = "editor", 
        #   height = "500px", 
        #   hide_mode_switch = FALSE
        # )
      )
    )
  ),

  # The Dashboard Footer
  dashboardFooter(
    left = HTML("<p class='text-muted m-0'><b>Sistema Unificado de Recomendación Escolar</b> &copy; Universidad del Caribe</p>"), 
    right = HTML("<p class='m-0'>Made with <i class='fas fa-heart text-danger'></i> by <b>Kenneth</b></p>"), 
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

  # use the waiter functionality
  useWaiter(),

  # wrapper container for login
  div(id = "login_container"),

  # wrapper container for dashboard
  div(id = "dashboard_container")
)

server <- function(input, output, session) {
  data <- reactiveValues()
  
  # initially we insert the login form
  insertUI(
    selector = "#login_container",
    where = "afterBegin",
    ui = login
  )

  # if login form button is pressed
  observeEvent(input$acceder, {
    # then remove the current login container
    removeUI(
      selector = "#login_container"
    )
    
    # verify if credentials are correct
    if(validateCredentials(as.character(input$id_user), as.character(input$password))){
      # if so, then we get user data
      data$student_data <- getData(as.character(input$id_user))
      data$notificationData <- notificationData
      data$messageData <- messageData
      data$taskData <- taskData
      data$payments <- payments
      data$aditionals <- aditionals(data$student_data$career$study_plan)
      data$workshops <- workshops(data$student_data$career$study_plan)
      data$foreign_languages <- foreign_languages(data$student_data$career$study_plan)
      data$practices <- practices(data$student_data$career$current_practices)
      data$internal_projects <- internal_projects(data$student_data$career$study_plan)
      data$external_projects <- external_projects(data$student_data$career$study_plan)
      ## dbDisconnect(conn)
      
      
      # show a waiter while loading page
      waiter_show(html = spin_fading_circles())
      
      # if does, insert the bashboard in the page
      insertUI(
        selector = "#dashboard_container",
        where = "afterBegin",
        ui = dashboard
      )
      
      # hide waiter after page is loaded
      waiter_hide()
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

      sendSweetAlert(
        session = session,
        title = "Opsss...",
        text = "¡Tus credenciales son incorrectas!",
        type = "error"
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
      name = data$student_data$username,
      image = data$student_data$profile_picture,
      title = data$student_data$career$name,
      subtitle = data$student_data$career$department,
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
    messages <- apply(data$messageData, 1, function(row) {
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
    notifications <- apply(data$notificationData, 1, function(row) {
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
    tasks <- apply(data$taskData, 1, function(row) {
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
      title = "Primer ciclo",
      value = "Créditos: 100/100",
      subtitle = em("Concluido"),
      icon = icon("check-circle"),
      color = "lime",
      elevation = 2,
      iconElevation = 0,
      gradient = TRUE,
      fill = TRUE
    )
  })

  output$second_cycle <- renderInfoBox({
    infoBox(
      title = "Segundo ciclo",
      value = "Créditos: 80/100",
      subtitle = em("En progreso"),
      icon = icon("circle-notch", class = "fa-spin"),
      color = "info",
      elevation = 2,
      iconElevation = 0,
      gradient = TRUE,
      fill = TRUE
    )
  })

  output$third_cycle <- renderInfoBox({
    infoBox(
      title = "Tercer ciclo",
      value = "Créditos: 60/80",
      subtitle = em("Reprobadas: 1", class = "text-warning"),
      icon = icon("exclamation-circle"),
      color = "danger",
      elevation = 2,
      iconElevation = 0,
      gradient = TRUE,
      fill = TRUE
    )
  })

  output$fourth_cycle <- renderInfoBox({
    infoBox(
      title = "Cuarto ciclo",
      value = "Créditos: 0/150",
      subtitle = em("Sin comenzar", class = "text-muted"),
      icon = icon("pause-circle"),
      color = "gray-dark",
      elevation = 2,
      iconElevation = 0,
      gradient = TRUE,
      fill = TRUE
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
      name = data$student_data$id_user,
      image = data$student_data$ profile_picture
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
    datagrid(
      data$payments(data$student_data$id_user)[,4:9],
      theme = "striped"
    )
  })
  
  output$payments_chart <- renderChart({
    data$payments(data$student_data$id_user) %>% 
    arrange(Fecha) %>% 
    chart(aes(x = Vencimiento, y = Monto), type = "area")
  })
  
  output$speedometer <- renderChart({
    chart(list(Años = 4), type = "gauge", height = "500px") %>% 
      chart_options(
        circularAxis = list(scale = list(min = 4, max = 8), title = "Permanencia"),
        series = list(angleRange = list(start = 225, end = 135)),
        plot = list(
          bands = list(
            list(range = c(4, 6), color = "#55bf3b"),
            list(range = c(6, 8), color = "#dddf0d"),
            list(range = c(8, 10), color = "#ffa500"),
            list(range = c(10, 12), color = "#df5353")
          )
        ),
        theme = list(plot = list(bands = list(barWidth = 40)))
      )
  })

  # Render school grades
  output$grades <- renderChart({
    chart(economics, aes(date, psavert), type = "line")
  })
  
  # Render markdown editor
  # observeEvent(input$show, {
  #   show_editor(.id = "editor")
  # })
  
  # observeEvent(input$hide, {
  #   hide_editor(.id = "editor")
  # })

  output$user_information <- renderUI({
    fluidRow(
      userBox(
        title = userDescription(
          title = paste(data$student_data$username, data$student_data$first_lastname, data$student_data$second_lastname),
          subtitle = data$student_data$career$name,
          image = data$student_data$profile_picture,
          backgroundImage = "https://cdn.statically.io/img/wallpaperaccess.com/full/1119564.jpg"
        ),
        
        width = 6,
        status = "olive",
        collapsible = FALSE,
        closable = FALSE,
        maximizable = FALSE,
        
        div(
          class = "p-5",
          tabBox(
            id = "tabcard",
            title = "Mis datos",
            width = 12,
            collapsible = FALSE,
            closable = FALSE,
            maximizable = FALSE,
            icon = icon("list-alt"),
            elevation = 2,
            side = "left",
            footer = p("Esto es el footer", class = "m-0 small text-muted"),
            tabPanel(
              title = "Mis datos", 
              "Content 1"
            ),

            tabPanel(
              title = "Familiares", 
              "Content 2"
            ),

            tabPanel(
              title = "Trabajo", 
              "Content 3"
            ),
            
            tabPanel(
              title = "Procedencia",
              "Content 4"
            )
          )
        ),

        footer = p(
            class = "m-0 small text-muted",
            "Última actualización: recientemente"
          )
      ),

      box(
        title = "Ubicaciones",
        width = 6,
        mapboxer(
          width = "100%",
          center = c(-73.9165, 40.7114),
          zoom = 10
        )
      )
    )
  })

  output$teachers_forms <- renderUI({
    # Render all the teachers evalution performance
    fluidRow(
      userBox(
        title = userDescription(
          title = p("Pensamiento crítico para ingeniería", class = "m-3"),
          subtitle = p("Mtra. Erika Eréndira Zavala López", class = "m-3"),
          type = 2,
          image = "https://www.unicaribe.mx/static/files/profesores/cbei/erika-zavala.153bf1ac7080.jpg"
        ),

        width = 4,
        height = "150px",
        status = "success",
        boxToolSize = "xl",
        "Some text here",
        footer = p("Ultima modificación: 01-07-2022 14:35:17", class = "m-0 small text-muted")
      ),

      userBox(
        title = userDescription(
          title = p("Proyecto terminal", class = "m-3"),
          subtitle = p("Mtra. Nancy Aguas García", class = "m-3"),
          type = 2,
          image = "https://www.unicaribe.mx/static/files/profesores/cbei/nancy-aguas.7b4e185a81f0.jpg"
        ),

        width = 4,
        height = "150px",
        status = "info",
        boxToolSize = "xl",
        "Some text here",
        footer = p("Ultima modificación: 31-06-2022 10:17:46", class = "m-0 small text-muted")
      ),

      userBox(
        title = userDescription(
          title = p("Minería de datos", class = "m-3"),
          subtitle = p("Dr. Héctor Fernando Gómez García", class = "m-3"),
          type = 2,
          image = "https://www.unicaribe.mx/static/files/profesores/cbei/fernando-gomez.0731bdac903f.jpg"
        ),

        width = 4,
        height = "150px",
        status = "danger",
        background = "white",
        gradient = TRUE,
        boxToolSize = "xl",
        "Some text here",
        footer = p("Ultima modificación: 31-06-2022 10:17:46", class = "m-0 small text-muted")
      ),

      userBox(
        title = userDescription(
          title = p("Pensamiento crítico para ingeniería", class = "m-3"),
          subtitle = p("Mtra. Erika Eréndira Zavala López", class = "m-3"),
          type = 2,
          image = "https://www.unicaribe.mx/static/files/profesores/cbei/erika-zavala.153bf1ac7080.jpg"
        ),

        width = 4,
        height = "150px",
        status = "success",
        boxToolSize = "xl",
        "Some text here",
        footer = p("Ultima modificación: 01-07-2022 14:35:17", class = "m-0 small text-muted")
      ),

      userBox(
        title = userDescription(
          title = p("Proyecto terminal", class = "m-3"),
          subtitle = p("Mtra. Nancy Aguas García", class = "m-3"),
          type = 2,
          image = "https://www.unicaribe.mx/static/files/profesores/cbei/nancy-aguas.7b4e185a81f0.jpg"
        ),

        width = 4,
        height = "150px",
        status = "info",
        boxToolSize = "xl",
        "Some text here",
        footer = p("Ultima modificación: 31-06-2022 10:17:46", class = "m-0 small text-muted")
      ),

      userBox(
        title = userDescription(
          title = p("Minería de datos", class = "m-3"),
          subtitle = p("Dr. Héctor Fernando Gómez García", class = "m-3"),
          type = 2,
          image = "https://www.unicaribe.mx/static/files/profesores/cbei/fernando-gomez.0731bdac903f.jpg"
        ),

        width = 4,
        height = "150px",
        status = "danger",
        boxToolSize = "xl",
        "Some text here",
        footer = p("Ultima modificación: 31-06-2022 10:17:46", class = "m-0 small text-muted")
      )
    )
  })
}

options(shiny.port = 4000)
shinyApp(ui, server)
