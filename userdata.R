id_user <- student_data$id_user # "170300075"

# logout user output
username <- student_data$username# "Kenneth"
profile_picture <- "profiles/170300075.jpg"
career <- student_data$career #"Ingeniería en datos"
department <- student_data$career$department #"Ciencias Básicas e Ingenierías"

# dropdown menu output
messageData <- data.frame(
    from = I(list("Erika Zavala")),
    message = I(list("Necesito comunicarme contigo.")),
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

library(DBI)
library(RMariaDB)

# read the environmental variables file
readRenviron(".env")

# Get student credentials
# id_user <- Sys.getenv('ID')
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
payments <- dbGetQuery(conn, paste0("SELECT * FROM pagos_", id_user))

# Get data for academic offer
aditionals <- dbGetQuery(conn, paste0("SELECT * FROM secciones_", id_user))
workshops <- dbGetQuery(conn, paste0("SELECT * FROM talleres_", id_user))
foreign_languages <- dbGetQuery(conn, paste0("SELECT * FROM lengua_extranjera_", id_user))

# Get data for professional practices
practices <- dbGetQuery(conn, paste0("SELECT * FROM practicas_", id_user))

# Get data for social service
external_projects <- dbGetQuery(conn, paste0("SELECT * FROM proyectos_externos_", id_user))
internal_projects <- dbGetQuery(conn, paste0("SELECT * FROM proyectos_internos_", id_user))

# Disconnet from database
dbDisconnect(conn)