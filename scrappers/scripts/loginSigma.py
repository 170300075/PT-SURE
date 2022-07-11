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
    ""
    # Open the web browser
    driver = webdriver.Edge()
    # Maximize the window
    driver.maximize_window()