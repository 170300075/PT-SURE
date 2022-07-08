library(mongolite)

# read the environmental variables file
readRenviron(".env")

MONGODB_URI <- Sys.getenv('MONGODB_URI')

students <- mongo(collection = "users", db = "sure", url = MONGODB_URI)
profile_picture <- "profiles/170300075.jpg"

# dropdown menu output
messageData <- data.frame(
    from = I(list("Erika Zavala")),
    message = I(list("Necesito comunicarme contigo Kenneth")),
    icon = I(list("telegram-plane")),
    time = I(list(NULL)),
    href = I(list(NULL)),
    image = I(list("https://www.unicaribe.mx/static/files/profesores/cbei/erika-zavala.153bf1ac7080.jpg")),
    color = I(list("info")),
    inputId = I(list(NULL)),
    stringsAsFactors = FALSE
)

# dropdown notification output
notificationData <- data.frame(
    text = I(list("Calificación nueva")),
    icon = I(list("user-check")),
    status = I(list("olive")),
    href = I(list(NULL)),
    inputId = I(list(NULL)),
    stringsAsFactors = FALSE
)

# dropdown task output
taskData <- data.frame(
    text = I(list("Mi progreso")),
    value = I(list(10)),
    color = I(list("info")),
    href = I(list(NULL)),
    inputId = I(list(NULL)),
    stringsAsFactors = FALSE
)


getData <- function(input_id_user) {
    # Obtener los datos del id del usuario ingresado
    student_data <- students$find(
        paste0('{"id_user":"', input_id_user,'"}'), 
        limit = 1
    )

    return(student_data)
}

validateCredentials <- function(input_id_user, input_password) {
    student_data <- getData(input_id_user)

    # Obtener la contraseña real del usuario
    password <- student_data$password
    
    # Verificar si la contraseña real y la ingresada coinciden
    if(password == input_password) {
        # si coinciden, regresar TRUE
        return(TRUE)
    }

    else {
        # si no coindiden, regresar FALSE
        return(FALSE)
    }
}


library(DBI)
library(RMariaDB)

user <- Sys.getenv('MYSQL_ADDON_USER')
password <- Sys.getenv('MYSQL_ADDON_PASSWORD')
host <- Sys.getenv('MYSQL_ADDON_HOST')
port <- Sys.getenv('MYSQL_ADDON_PORT')
dbname <- Sys.getenv('MYSQL_ADDON_DB')

conn <- dbConnect(
  RMariaDB::MariaDB(),
  user = user,
  password = password,
  host = host,
  port = port,
  dbname = dbname
)

dbListTables(conn)

# Get payments data
payments <- function(id_user) {
    dbGetQuery(conn, paste0("SELECT * FROM pagos_", id_user))
}

# Get data for academic offer
aditionals <- function(id_user) {
    dbGetQuery(conn, paste0("SELECT * FROM secciones_", id_user))
}

workshops <- function(id_user) {
    dbGetQuery(conn, paste0("SELECT * FROM talleres_", id_user))
}

foreign_languages <- function(id_user) {
    dbGetQuery(conn, paste0("SELECT * FROM lengua_extranjera_", id_user))
    }

# Get data for professional practices
practices <- function(id_user) {
    dbGetQuery(conn, paste0("SELECT * FROM practicas_", id_user))
}

# Get data for social service
external_projects <- function(id_user) {
    dbGetQuery(conn, paste0("SELECT * FROM proyectos_externos_", id_user))
}

internal_projects <- function(id_user) {
    dbGetQuery(conn, paste0("SELECT * FROM proyectos_internos_", id_user))
}

# Disconnet from database
# dbDisconnect(conn)