 my_packages <- c("shiny", "bs4Dash", "sortable", "DBI", 
                  "RMariaDB", "dplyr", "data.table", "DiagrammeR",
                  "reticulate", "shinyWidgets", "highcharter", "plotly",
                  "toastui", "DT", "telegram.bot", "mapboxer") 

# Install required packages
lapply(my_packages, install.packages, character = TRUE)

# Import database libraries
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


# Stablish connection to database `sigmaa`
conn <- dbConnect(
  RMariaDB::MariaDB(),
  user = user,
  password = password,
  host = host,
  port = port,
  dbname = dbname
)

dbGetQuery(conn, "CREATE TABLE messages(`id_message` INT NOT NULL AUTO_INCREMENT, `from` VARCHAR(20) NOT NULL, `message` TEXT NOT NULL, `icon` VARCHAR(15) NULL, `time` DATE NULL, `href` TEXT NULL, `image` TEXT NULL, `color` VARCHAR(10) NULL, `inputId` VARCHAR(20) NULL, PRIMARY KEY(`id_message`));")

dbGetQuery(conn, "CREATE TABLE notifications(`id_notification` INT NOT NULL AUTO_INCREMENT, `text` VARCHAR(30) NOT NULL, `icon` VARCHAR(15) NULL, `status` VARCHAR(10) NOT NULL, `href` TEXT NULL, `inputId` VARCHAR(20) NULL, PRIMARY KEY(`id_notification`));")

dbGetQuery(conn, "CREATE TABLE tasks(`id_task` INT NOT NULL AUTO_INCREMENT, `text` VARCHAR(30) NOT NULL, `value` INT NOT NULL, `color` VARCHAR(10) NULL, `href` TEXT NULL, `inputId` VARCHAR(20) NULL, PRIMARY KEY(`id_task`));")