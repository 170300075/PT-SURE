# read the environmental variables file
readRenviron(".env")

# Get student credentials
username = Sys.getenv('ID')
password = Sys.getenv('PASS')

# Stablish connection to database ´sigmaa´
conn <- dbConnect(RMariaDB::MariaDB(), user = "root", password = "", dbname = "sigmaa")

# Get data for academic offer
adicionales <- dbGetQuery(conn, paste0("SELECT * FROM secciones_", username))
talleres <- dbGetQuery(conn, paste0("SELECT * FROM talleres_", username))
lengua_extranjera <- dbGetQuery(conn, paste0("SELECT * FROM lengua_extranjera_", username))

# Get data for professional practices
practicas_profesionales <- dbGetQuery(conn, paste0("SELECT * FROM practicas_", username))

# Get data for social service
proyectos_externos <- dbGetQuery(conn, paste0("SELECT * FROM proyectos_externos_", username))
proyectos_internos <- dbGetQuery(conn, paste0("SELECT * FROM proyectos_internos_", username))
# Disconnet from database
dbDisconnect(conn)