library(mongolite)

MONGODB_URI <- "mongodb+srv://170300075:cLAET368ZSHGbkY5@cluster0.ynkmfoz.mongodb.net/?retryWrites=true&w=majority"

students <- mongo(collection = "users", db = "sure", url = MONGODB_URI)


students$count()

students$iterate()$one()

id_user <- 170300075

student_data <- students$find(
  paste0('{"id_user":"', id_user,'"}'), 
  limit = 1
)

View(student_data)

username <- student_data$username
first_lastname <- student_data$first_lastname
career <- student_data$career$name
department <- student_data$career$department

