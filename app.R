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

# Stablish connection to database ´sigmaa´
conn <- dbConnect(RMariaDB::MariaDB(), user = 'root', password = '', dbname = 'sigmaa')

adicionales <- dbGetQuery(conn, 'SELECT * FROM secciones_210300580')
talleres <- dbGetQuery(conn, 'SELECT * FROM talleres_210300580')
lengua_extranjera <- dbGetQuery(conn, 'SELECT * FROM lengua_extranjera_210300580')

dbDisconnect(conn)

# Mi componente para generar tablas
subject <- function(data, status){
  htmlTemplate("components/table.html", 
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
loginForm <- function(){
  htmlTemplate("components/login.html")
}

# Iframe
my_iframe <- function(){
  htmlTemplate("www/processing/index.html")
}


# UI for dashboard
ui <- dashboardPage(
  dashboardHeader(
    rightUi = userOutput('user'),
    tags$script("processing/p5.min.js"),
    tags$script("processing/jExample.js")
  ),
  dashboardSidebar(
    collapsed = FALSE,
    expandOnHover = FALSE,
    
    bs4SidebarUserPanel(
      name = 'Kenneth',
      image = 'profiles/170300075.jpg'
    ),
    
    sidebarMenu(
      id = 'carrera',
      sidebarHeader('Carrera'),
      
      menuItem(
        text = 'Progreso',
        tabName = 'progreso',
        icon = ionicon(name = 'speedometer')
      ),
      
      menuItem(
        text = 'Rendimiento',
        tabName = 'rendimiento',
        icon = ionicon('stats')
      ),
      
      menuItem(
        text = 'Economía',
        tabName = 'economia',
        icon = ionicon('cash')
      )
    ),
    
    sidebarMenu(
      id  = 'asignaturas',
      sidebarHeader('Asignaturas'),
      menuItem(
        text = 'Horario',
        tabName = 'horario',
        icon = icon('calendar-o')
      ),
      
      menuItem(
        text = 'Academicas',
        tabName = 'academicas',
        icon = icon('institution')
      ),
      
      menuItem(
        text = 'Practicas',
        tabName = 'practicas',
        icon = icon('newspaper-o')
      ),
      
      menuItem(
        text = 'Servicio',
        tabName = 'servicio',
        icon = icon('hospital-o')
      )
    ),
    
    sidebarMenu(
      id = 'utilidades',
      sidebarHeader('Utilidades'),
      menuItem(
        text = 'Calendario',
        tabName = 'calendario',
        icon = icon('calendar')
      )
    ),
    
    sidebarMenu(
      id = 'bot',
      sidebarHeader('Bot'),
      menuItem(
        text = 'Autocarga',
        tabName = 'autocarga',
        icon = icon('circle-o-notch')
      )
    ),
    
    sidebarMenu(
      id = 'cuenta',
      sidebarHeader('Mi cuenta'),
      menuItem(
        text = 'Configuración',
        tabName = 'configuracion',
        icon = icon('gear')
      )
    )
    
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = 'progreso',
        h1('Mi progreso personal'),
        br(),
        fluidRow(
          # Cajas de informacion
          infoBox(title = h5('Primer ciclo'), 
                 value = "Créditos: 100/100",
                 width = 3,
                 subtitle = em('Concluido'), 
                 icon = ionicon(name = "checkmark"), 
                 color = 'lime',
                 elevation = 2, iconElevation = 2),
          
          # Cajas de informacion
          infoBox(title = h5('Segundo ciclo'), 
                 value = "Créditos: 80/100", 
                 width = 3,
                 subtitle = em('En progreso'), 
                 icon = ionicon(name = 'hourglass'), 
                 color = 'info',
                 elevation = 2, iconElevation = 2),
          
          # Cajas de informacion
          infoBox(title = h5('Tercer ciclo'), 
                 value = "Créditos: 60/80", 
                 width = 3,
                 subtitle = em(class = 'text-danger','Reprobadas: 1'), 
                 icon = ionicon('sad'), 
                 color = 'danger',
                 elevation = 2, iconElevation = 2),
          
          # Cajas de informacion
          infoBox(title = h5('Cuarto ciclo'), 
                 value = "Créditos: 0/150", 
                 width = 3,
                 subtitle = em(class='text-muted' ,'Sin comenzar'), 
                 icon = ionicon('lock'), 
                 color = 'gray',
                 elevation = 2, iconElevation = 2),
        ),
        
        fluidRow(
          column(width = 12, offset = 0, br(), br(),
            box(
             title = h4('Mapa Curricular'),
             closable = FALSE,
             solidHeader = TRUE,
             collapsible = FALSE,
             width = 12,
             status = "navy",
             # Mapa curricular
             # grVizOutput(outputId = 'mermaid'), 
             imageOutput(outputId = "mapa_curricular")
             # htmlOutput(outputId = 'diagram')
             # my_iframe()
            )       
          )
        )
      ),
      
      tabItem(
        tabName = 'rendimiento',
        h1('Indicadores de rendimiento escolar')
      ),
      
      tabItem(
        tabName = 'economia',
        h1('Inversión escolar')
      ),
      
      tabItem(
        tabName = 'horario',
        h1('Mi horario escolar')
      ),
      
      tabItem(
        tabName = 'academicas',
        h1('Oferta académica - Verano 2022'),
        tabsetPanel(
          id = 'tabset',
          tabPanel(
            title = 'Adicionales',
            br(),
            bs4Table(
              cardWrap = TRUE,
              bordered = TRUE,
              striped = TRUE,
              adicionales[,4:12] %>% arrange(`Asignatura`, `Profesor`)
            ) 
          ),
          
          tabPanel(
            title = 'Talleres',
            br(),
            bs4Table(
              cardWrap = TRUE,
              bordered = TRUE,
              striped = TRUE,
              talleres[,4:12] %>% arrange(`Asignatura`)
            )
          ),
          
          tabPanel(
            title = 'Lengua extrajera',
            br(),
            bs4Table(
              cardWrap = TRUE,
              bordered = TRUE,
              striped = TRUE,
              lengua_extranjera[,4:12] %>% arrange(`Asignatura`)
            )
          ),
          
          tabPanel(
            title = 'Crear un horario',
            br(),
            
            # Bucket List
            fluidRow(
              column(
                width = 12,
                box(
                  title = h4('Crear un horario'),
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
        tabName = 'practicas',
        h1('Oferta de prácticas profesionales')
      ),
      
      tabItem(
        tabName = 'servicio',
        h1('Oferta de servicio social')
      ),
      
      tabItem(
        tabName = 'calendario',
        h1('Calendario escolar')
      ),
      
      tabItem(
        tabName = 'autocarga',
        h1('Bot de selección academica'),
        
        wellPanel(
          actionButton(
            inputId = 'lanzar_bot',
            label = 'Lanzar bot de autoselección',
            icon = icon('rocket'), 
            status = 'primary', 
            outline = FALSE,
            size = 'lg')
        ),
      ),
      
      tabItem(
        tabName = 'configuracion',
        h1('Ajustes de mi cuenta'),
        br(), br(), br(), br(),
        fluidRow(
          column( width = 8, offset = 4,
            userBox(
              title = userDescription(
                  'Kenneth Díaz González',
                  subtitle = 'Data Engineer',
                  type = 1,
                  image = 'profiles/170300075.jpg'
              ),
              
              status = 'navy',
              closable = FALSE,
              elevation = 4,
              collapsible = FALSE,
              maximizable = FALSE,
              # width = 6,
              wellPanel(
                passwordInput(
                  inputId = 'contra_actual',
                  label = 'Contraseña actual',
                  width = '100%',
                  placeholder = 'Escribe aquí'
                ),
                
                passwordInput(
                  inputId = 'nueva_contra',
                  label = 'Nueva contraseña',
                  width = '100%',
                  placeholder = 'Tu nueva contraseña'
                ),
                
                passwordInput(
                  inputId = 'nueva_contra_2',
                  label = 'Confirma nueva contraseña',
                  width = '100%',
                  placeholder = 'Escribe de nuevo'
                ),
                br(),
                actionButton(
                  inputId = 'cambiar_contra', 
                  label = 'Actualizar contraseña',
                  icon = icon('gear'), 
                  status = 'success',
                  size = 'lg', 
                  width = '100%',
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

server <- function(input, output, session){
    
  # User Logout
  output$user <- renderUser({
    dashboardUser(
      name = 'Kenneth',
      image = 'profiles/170300075.jpg',
      title = 'Ingeniería de datos',
      subtitle = 'Ciencias Básicas e Ingenierías',
      footer = fluidRow(
        dashboardUserItem(
          width = 12,
          
          actionButton(
            inputId = 'logout', 
            label = 'Cerrar sesión', 
            icon = ionicon('exit'), 
            status = 'primary') 
        )
      ),
      status = 'navy'
    )
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

options(shiny.autoreload = TRUE)
shinyApp(ui, server)