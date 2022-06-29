# Shiny libraries
library(shiny)
library(bs4Dash)

# Library to sort lists
library(sortable)

# Libraries to connect to databases
library(DBI)
library(RMariaDB)

# Libraries manipulate data
library(dplyr)
library(data.table)

# Library to create mermaid diagrams
library(DiagrammeR)

# Library for calendar
library(toastui)
library(DT)

library(bslib)
library(lsr)

# Get the custom shiny inputs
source("matriculaInput.R")
source("contraseñaInput.R")

# Get all the student data
source("data.R")

# Mi componente para generar tablas
subject <- function(data, status){
  htmlTemplate("table.html", 
               asignatura = data[1],
               profesor = data[2],
               modalidad = data[3],
               lunes = data[4],
               martes = data[5],
               miercoles = data[6],
               jueves = data[7],
               viernes = data[8],
               sabado = data[9],
               color = status)
}

# Mi componente para formulario de login
login <- page(
  # theme = bs_theme(version = 5),
  tags$head(tags$script(src = "showPassword.js")),
  tags$body(class = "bg-light"),
  div(
    id = "placeholder",
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

# Iframe
my_iframe <- function(){
  htmlTemplate("www/processing/index.html")
}

# UI for dashboard
dashboard <- dashboardPage(
  # Dashboard header
  dashboardHeader(
    # header config
    status = "navy",
    border = TRUE,
    fixed = TRUE,
    
    # User
    rightUi = userOutput("user"),
    tags$script("processing/p5.min.js"),
    tags$script("processing/jExample.js"),
    
    # title dashboard
    title = dashboardBrand(
      title = NULL,
      color = NULL,
      href = NULL,
      image = "images/assets/logotipo.png",
      opacity = 1
    ),
    
    # Notifications at right
    leftUi = tagList(
      dropdownMenu(
        type = "messages",
        # message items
        messageItem(
          from = "Erika Zavala",
          message = "Necesito comunicarme contigo",
          icon = shiny::icon("user"),
          time = NULL,
          href = NULL,
          image = NULL,
          color = "secondary",
          inputId = NULL
        )
      ),
    
      dropdownMenu(
        type = "notifications",
        # Notification items
        notificationItem(
          text = "Error!",
          icon = shiny::icon("exclamation-triangle"),
          status = "danger",
          href = NULL,
          inputId = NULL
        )
      ),
      
      dropdownMenu(
        type = "tasks",
        # Task items
        taskItem(text = "Mi progreso", value = 10, color = "info", href = NULL, inputId = NULL)
      )
    )
  ),

  # Dashboard Sidebar
  dashboardSidebar(
    skin = "light",
    status = "navy",
    elevation = "3",
    collapsed = FALSE,
    expandOnHover = FALSE,
    
    # User Panel
    bs4SidebarUserPanel(
      name = username,
      image = "profiles/170300075.jpg"
    ),
    
    sidebarMenu(
      id = "carrera",
      sidebarHeader("Carrera"),
      
      menuItem(
        text = "Progreso",
        tabName = "progreso",
        icon = ionicon(name = "speedometer")
      ),
      
      menuItem(
        text = "Rendimiento",
        tabName = "rendimiento",
        icon = ionicon("stats")
      ),
      
      menuItem(
        text = "Economía",
        tabName = "economia",
        icon = ionicon("cash")
      )
    ),
    
    sidebarMenu(
      id  = "asignaturas",
      sidebarHeader("Asignaturas"),
      menuItem(
        text = "Horario",
        tabName = "horario",
        icon = icon("calendar-o")
      ),
      
      menuItem(
        text = "Academicas",
        tabName = "academicas",
        icon = icon("institution")
      ),
      
      menuItem(
        text = "Practicas",
        tabName = "practicas",
        icon = icon("newspaper-o")
      ),
      
      menuItem(
        text = "Servicio",
        tabName = "servicio",
        icon = icon("hospital-o")
      )
    ),
    
    sidebarMenu(
      id = "utilidades",
      sidebarHeader("Utilidades"),
      menuItem(
        text = "Calendario",
        tabName = "calendario",
        icon = icon("calendar")
      )
    ),
    
    sidebarMenu(
      id = "bot",
      sidebarHeader("Bot"),
      menuItem(
        text = "Autocarga",
        tabName = "autocarga",
        icon = icon("circle-o-notch")
      )
    ),
    
    sidebarMenu(
      id = "cuenta",
      sidebarHeader("Mi cuenta"),
      menuItem(
        text = "Configuración",
        tabName = "configuracion",
        icon = icon("gear")
      )
    )
    
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "progreso",
        h1("Mi progreso personal"),
        br(),
        fluidRow(
          # Cajas de informacion
          infoBox(title = h5("Primer ciclo"), 
                 value = "Créditos: 100/100",
                 width = 3,
                 subtitle = em("Concluido"), 
                 icon = ionicon(name = "checkmark"), 
                 color = "lime",
                 elevation = 2, iconElevation = 2),
          
          # Cajas de informacion
          infoBox(title = h5("Segundo ciclo"), 
                 value = "Créditos: 80/100", 
                 width = 3,
                 subtitle = em("En progreso"), 
                 icon = ionicon(name = "hourglass"), 
                 color = "info",
                 elevation = 2, iconElevation = 2),
          
          # Cajas de informacion
          infoBox(title = h5("Tercer ciclo"), 
                 value = "Créditos: 60/80", 
                 width = 3,
                 subtitle = em(class = "text-danger", "Reprobadas: 1"), 
                 icon = ionicon("sad"), 
                 color = "danger",
                 elevation = 2, iconElevation = 2),
          
          # Cajas de informacion
          infoBox(title = h5("Cuarto ciclo"), 
                 value = "Créditos: 0/150", 
                 width = 3,
                 subtitle = em(class="text-muted" ,"Sin comenzar"), 
                 icon = ionicon("lock"), 
                 color = "gray",
                 elevation = 2, iconElevation = 2),
        ),
        
        fluidRow(
          column(width = 12, offset = 0, br(), br(),
            box(
             title = h4("Mapa Curricular"),
             closable = FALSE,
             solidHeader = TRUE,
             collapsible = FALSE,
             width = 12,
             status = "navy",
             # Mapa curricular
             # grVizOutput(outputId = "mermaid") 
             imageOutput(outputId = "mapa_curricular")
             # htmlOutput(outputId = "diagram")
             # my_iframe()
            )       
          )
        )
      ),
      
      tabItem(
        tabName = "rendimiento",
        h1("Indicadores de rendimiento escolar")
      ),
      
      tabItem(
        tabName = "economia",
        h1("Inversión escolar")
      ),
      
      tabItem(
        tabName = "horario",
        h1("Mi horario escolar")
      ),
      
      tabItem(
        tabName = "academicas",
        h1("Oferta académica - Verano 2022"),
        tabsetPanel(
          id = "tabset_academicas",
          tabPanel(
            title = "Adicionales",
            br(),
            box(
              title = h4("Adicionales"),
              closable = FALSE,
              solidHeader = TRUE,
              collapsible = FALSE,
              width = 12,
              status = "teal",
              DT::dataTableOutput(outputId = "tabla_adicionales")
            )
          ),
          
          tabPanel(
            title = "Talleres",
            br(),
            # bs4Table(
            #   cardWrap = TRUE,
            #   bordered = TRUE,
            #   striped = TRUE,
            #   talleres[,4:12] %>% arrange(`Asignatura`)
            # )
            
            box(
              title = h4("Talleres"),
              closable = FALSE,
              solidHeader = TRUE,
              collapsible = FALSE,
              width = 12,
              status = "teal",
              dataTableOutput(outputId = "tabla_talleres")
            )
          ),
          
          tabPanel(
            title = "Lengua extrajera",
            br(),
            bs4Table(
              cardWrap = TRUE,
              bordered = TRUE,
              striped = TRUE,
              lengua_extranjera[,4:12] %>% arrange(`Asignatura`)
            )
          ),
          
          tabPanel(
            title = "Crear un horario",
            br(),
            
            # Bucket List
            fluidRow(
              column(
                width = 12,
                box(
                  title = h4("Crear un horario"),
                  closable = FALSE,
                  solidHeader = TRUE,
                  collapsible = FALSE,
                  width = 12,
                  status = "navy",
                  bucket_list(
                    header = "Arrastra y suelta en el contenedor las asignaturas deseadas",
                    group_name = "bucket_list_group",
                    orientation = "horizontal",
                    options = sortable_options(
                      sort = TRUE,
                      disabled = TRUE
                    ),
                    
                    add_rank_list(
                      text = "Mi horario deseado",
                      labels = NULL,
                      input_id = "rank_list_2"
                    ),
                    
                    add_rank_list(
                      text = "Arrastrame de aquí",
                      labels = 
                        # "Minería de datos",
                        # "Aprendizaje estadístico",
                        # "Introducción a la inteligencia artificial", 
                        # subject(c("Calculo diferencial", "Lesley", "Presencial", "9:00-11:00", "9:00-11:00", "9:00-11:00","9:00-11:00", "", "", "table-danger")),
                        # subject(c("A", "B", "C", 1,2,3,4,5,6, "table-primary")),
                        apply(X = adicionales[,4:12], MARGIN = 1, subject, status = "table-light")
                      ,
                      input_id = "rank_list_1"
                    )
                    
                  )
                ),
              )
            )
            
            # End Bucket List
          )
        )
      ),
      
      tabItem(
        tabName = "practicas",
        h1("Oferta de prácticas profesionales"),
        br(), br(),
        fluidRow(
          column(width = 12,
            box(
              title = h4("Verano 2022"),
              closable = FALSE, 
              solidHeader = TRUE,
              collapsible = FALSE, 
              width = 12,
              status = "navy",

              # Tabla
              bs4Table(
                cardWrap = TRUE,
                bordered = TRUE,
                striped = TRUE,
                practicas_profesionales %>% select(`Empresa`, `Área de desempeño`, `Ubicación`, `Espacios`) %>% arrange(`Empresa`)
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "servicio",
        h1("Oferta de servicio social"),
        br(), br(),
        
        tabsetPanel(
          id = "tabset_servicio",
          tabPanel(
            title = "Proyectos Internos",
            br(),
            bs4Table(
              cardWrap = TRUE,
              bordered = TRUE,
              striped = TRUE,
              proyectos_internos[,2:4] %>% arrange(`Proyecto`)
            )
          ),
          
          tabPanel(
            title = "Proyectos Externos",
            br(),
            bs4Table(
              cardWrap = TRUE,
              bordered = TRUE,
              striped = TRUE,
              proyectos_externos[,2:4] %>% arrange(`Proyecto`)
            )
          )
        )
      ),
      
      tabItem(
        tabName = "calendario",
        h1("Calendario escolar"),
        br(), br(),
        
        calendarOutput(outputId = "calendar", width = "100%", height = "600px")
      ),
      
      tabItem(
        tabName = "autocarga",
        h1("Bot de selección academica"),
        
        wellPanel(
          actionButton(
            inputId = "lanzar_bot",
            label = "Lanzar bot de autoselección",
            icon = icon("rocket"), 
            status = "primary", 
            outline = FALSE,
            size = "lg")
        ),
      ),
      
      tabItem(
        tabName = "configuracion",
        h1("Ajustes de mi cuenta"),
        br(), br(), br(), br(),
        fluidRow(
          column( width = 8, offset = 4,
            userBox(
              title = userDescription(
                  username,
                  subtitle = "Data Engineer",
                  type = 1,
                  image = "profiles/170300075.jpg"
              ),
              
              status = "navy",
              closable = FALSE,
              elevation = 4,
              collapsible = FALSE,
              maximizable = FALSE,
              # width = 6,
              wellPanel(
                passwordInput(
                  inputId = "contra_actual",
                  label = "Contraseña actual",
                  width = "100%",
                  placeholder = "Escribe aquí"
                ),
                
                passwordInput(
                  inputId = "nueva_contra",
                  label = "Nueva contraseña",
                  width = "100%",
                  placeholder = "Tu nueva contraseña"
                ),
                
                passwordInput(
                  inputId = "nueva_contra_2",
                  label = "Confirma nueva contraseña",
                  width = "100%",
                  placeholder = "Escribe de nuevo"
                ),
                br(),
                actionButton(
                  inputId = "cambiar_contra", 
                  label = "Actualizar contraseña",
                  icon = icon("gear"), 
                  status = "success",
                  size = "lg", 
                  width = "100%",
                  outline = FALSE
                )
              )
            )
          )
        )
      )
    )
  ),
  # skin selector
  controlbar = dashboardControlbar(
    collapsed = TRUE,
    div(class = "p-3", skinSelector()),
    pinned = FALSE
  )
)

ui <- div(
  # wrapper container for login
  div(id = "login_container"),

  # wrapper container for dashboard
  div(id = "dashboard_container")
)

server <- function(input, output, session){

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
      
      unlibrary(bslib)
      # if does, insert the bashboard placeholder in the page
      insertUI(
        selector = "#dashboard_container",
        where = "afterBegin",
        ui = uiOutput("dashboard")
      )

      output$dashboard <- renderUI({
        dashboard
      })
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

  
  # User Logout
  output$user <- renderUser({
    dashboardUser(
      name = "Kenneth",
      image = "profiles/170300075.jpg",
      title = "Ingeniería de datos",
      subtitle = "Ciencias Básicas e Ingenierías",
      footer = fluidRow(
        dashboardUserItem(
          width = 12,
          
          actionButton(
            inputId = "logout", 
            label = "Cerrar sesión", 
            icon = ionicon("exit"), 
            status = "primary") 
        )
      ),
      status = "navy"
    )
  })
  
  # Tabla adicionales
  output$tabla_adicionales <- DT::renderDataTable({
    adicionales[,4:12] %>% arrange(`Asignatura`, `Profesor`)
  })
  
  # Tabla talleres
  output$tabla_talleres <- DT::renderDataTable({
    talleres[,4:12] %>% arrange(`Asignatura`, `Profesor`)
  })
  
  # Calendar
  output$calendar <- renderCalendar({
    calendar(cal_demo_data())
  })
  
  # Plot mermaid plot (Interactive Curricular Map)
  output$mermaid <- renderGrViz({
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
  
  # Processing IFrame
  output$diagram <- renderUI({
    tags$iframe(src="index.html", width = "100%", height = "100%", frameborder = "no")
  })
  
  # Show curricular map
  output$mapa_curricular <- renderImage({
    list(src = "./www/images/curricular_maps/Mapa curricular ideal IDeIO.jpg", width = "100%")
  })
}

options(shiny.port = 3000)
options(shiny.autoreload = TRUE)
shinyApp(ui, server)
