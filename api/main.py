# Run with:
# uvicorn main:app --reload

# Biblioteca para leer archivos
import os
# Biblioteca para leer .env
from dotenv import load_dotenv
# Importamos la biblioteca para MongoDB
import pymongo
from pymongo import MongoClient
# Biblioteca para crear API en Python
from fastapi import FastAPI

# Rutas en otras carpetas
from routes.user import user


# Creamos un objeto FastAPI
app = FastAPI()

def loadEnvs(path):
    """
    This function returns all the environmental variables
    used to stablish database connections in both MySQL and MongoDB
    """
    load_dotenv(path)
    MYSQL_ADDON_URI = os.getenv('MYSQL_ADDON_URI')
    MONGODB_URI = os.getenv('MONGODB_URI')
    
    return({
        "MYSQL_ADDON_URI" : MYSQL_ADDON_URI, 
        "MONGODB_URI" : MONGODB_URI
    })

def openMongoDB(uri):
    """
    Allows to open a mongoDB connection
    """
    client = MongoClient(uri)
    return(client)

def closeMongoDB(client):
    """
    Allows to close a mongoDB connection
    """
    client.close()

# Cargamos las variables de ambiente
env = loadEnvs("../.env")

# Abrimos la conexion con la 
# base de datos de MongoDB
client = openMongoDB(env["MONGODB_URI"])
# Use a database and select a collection
db = client["sure"]

##############################################
#               API Endpoints                #          
##############################################

@app.get("/")
def root():
    return({
        "error" : "You need a valid token to make use of this API",
        "message" : "Please, go to the developer section and register a new application so you can get a token and will be able to access to this API"
    })

@app.get("/student_data")
def studentData(id_user):
    collection = db["users"]
    res = collection.find_one({"id_user":id_user})
    print(res)
    return(res["username"])

@app.get("/hello")
def hello(name):
    if name is None:
        return "Hello there!"
    else:
        return "Hello there " + name + "!"