# Libraries for selenium
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
# Waited conditionals for Selenium
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
# Dropdown selection support
from selenium.webdriver.support.select import Select

# Data Manipulations libraries
import pandas as pd
# Regular expressions library
import re
# Datetime functionalities
import time
# String manipulation
import string
# Mathematical operations
import numpy

def initializeWebDriver():
    """
    This function enable to use the user browser to run automatizated 
    scripts to interact with it 
    """
    # Open the web browser
    driver = webdriver.Edge()
    # Maximize the window
    driver.maximize_window()
    
    return(driver)


def loginSIGMAA(driver, user_id, password):
    """
    Allows to login using user credentials into
    the SIGMAA
    """
    # Buscar el campo de usuario y escribir el username
    userinput = driver.find_element(By.XPATH, '/html/body/div[2]/form/div/span[2]/input')
    userinput.send_keys(id_user)
    # Buscar el campo de contraseña y escribir el password
    passinput = driver.find_element(By.XPATH, '/html/body/div[2]/form/div/input')
    passinput.send_keys(password)
    # Buscar el botón de submit y dar clic para iniciar sesión
    submitinput = driver.find_element(By.XPATH, '/html/body/div[2]/form/button')
    submitinput.click()


def logoutSIGMAA(driver):
    """
    Allows to close logout from SIGMAA
    """
    # Encontrar el botón de cierre de sesión
    logout = driver.find_element(By.XPATH, '/html/body/div[2]/div/form/a')
    # Clic para cerrar sesión
    logout.click()
    
def openMySQLConnection(uri):
    """
    Creates a connection to database
    """
    engine = create_engine(uri + "?ssl=true")
    return(engine)
    
def closeMySQLConnection(engine):
    """
    Closes a connection tp
    """
    engine.dispose()
    
def loadEnvs(path):
    load_dotenv(path)
    MYSQL_ADDON_URI = os.getenv('MYSQL_ADDON_URI')
    MONGODB_URI = os.getenv('MONGODB_URI')