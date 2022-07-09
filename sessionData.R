library(mongolite)

# read the environmental variables file
readRenviron(".env")

MONGODB_URI <- Sys.getenv('MONGODB_URI')

students <- mongo(collection = "users", db = "sure", url = MONGODB_URI)

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

    # Si el usuario no existe
    if(length(student_data) == 0){
      return(FALSE)
    }
    
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
  dbname = dbname,
  ssl.ca = "DigiCertGlobalRootCA.crt.pem"
)

dbListTables(conn)

# Get payments data
payments <- function(id_user) {
    dbGetQuery(conn, paste0("SELECT * FROM pagos_", id_user))
}

# Get data for academic offer
aditionals <- function(study_plan) {
    dbGetQuery(conn, paste0("SELECT * FROM secciones_", tolower(study_plan)))
}

workshops <- function(study_plan) {
    dbGetQuery(conn, paste0("SELECT * FROM talleres_", tolower(study_plan)))
}

foreign_languages <- function(study_plan) {
    dbGetQuery(conn, paste0("SELECT * FROM lengua_extranjera_", tolower(study_plan)))
    }

# Get data for professional practices
practices <- function(id_practices) {
    dbGetQuery(conn, paste0("SELECT * FROM practicas_", tolower(id_practices)))
}

# Get data for social service
external_projects <- function(study_plan) {
    dbGetQuery(conn, paste0("SELECT * FROM proyectos_externos_", tolower(study_plan)))
}

internal_projects <- function(study_plan) {
    dbGetQuery(conn, paste0("SELECT * FROM proyectos_internos_", tolower(study_plan)))
}

# Disconnet from database
# dbDisconnect(conn)