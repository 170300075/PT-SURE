 my_packages <- c("shiny", "bs4Dash", "sortable", "DBI", 
                  "RMariaDB", "dplyr", "data.table", "DiagrammeR",
                  "reticulate", "shinyWidgets", "highcharter", "plotly",
                  "toastui", "DT") 

# Install required packages
lapply(my_packages, install.packages, character = TRUE)

# Import database libraries
library(DBI)
library(RMariaDB)

# Stablish connection to database `sigmaa`
conn <- dbConnect(RMariaDB::MariaDB(), username = 'root', password = '', dbname = "sure")

# Create database SURE if not exist
dbGetQuery(conn, "CREATE DATABASE IF NOT EXISTS sure")