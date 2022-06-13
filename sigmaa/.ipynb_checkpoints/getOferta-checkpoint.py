# Bibliotecas para usar Selenium
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains

# Bibliotecas para manipulación de datos
import pandas as pd

# Biblioteca de empresiones regulares
import re

op = webdriver.EdgeOptions()
op.add_argument('headless')
driver = webdriver.Edge(options = op)

url = 'https://uclb.ucaribe.edu.mx/sigmaav2/'
# Para acceder a la URL
driver.get(url)

# Configurar las credenciales de acceso al sigmaa
username = '170300075'
password = 'Maripau01'

# Buscar el campo de usuario y escribir el username
userinput = driver.find_element(By.XPATH, '/html/body/div[2]/form/div/span[2]/input')
userinput.send_keys(username)

# Buscar el campo de contraseña y escribir el password
passinput = driver.find_element(By.XPATH, '/html/body/div[2]/form/div/input')
passinput.send_keys(password)

# Buscar el botón de submit y dar clic para iniciar sesión
submitinput = driver.find_element(By.XPATH, '/html/body/div[2]/form/button')
submitinput.click()

ofertaAcademica = driver.find_element(By.XPATH, '/html/body/div[1]/div/div/div/div/div/ul[2]/li[1]/a')
ofertaAcademica.click()

# Extraer el contenido html de la pagina actual en selenium
dfs = pd.read_html(driver.page_source)

# Cambiar nombre de columnas
columnas = ['Tipo', 'Clave', 'Seccion', 'Asignatura', 'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'U1', 'U2', 'U3', 'U4']

for i in range(1, len(dfs)):
    dfs[i] = dfs[i].set_axis(columnas, axis=1)
    dfs[i] = dfs[i].drop(['U1', 'U2', 'U3', 'U4'], axis = 1)

for j in range(1, len(dfs)):
    mydf = dfs[j]
    
    splits = []
    string = mydf['Asignatura']

    for i in range(len(string)):
        lista = string[i].split('  ')
        splits.append(lista)

    asignaturas = []
    profesores = []
    modalidades = []

    for i in splits:
        asignaturas.append(i[0])
        profesores.append(i[1])
        modalidades.append(i[2])

    mydf['Asignatura'] = asignaturas
    mydf.insert(4, 'Profesor', profesores)
    mydf.insert(5, 'Modalidad', modalidades)

# Importar biblioteca para conexion a base de datos
from sqlalchemy import create_engine
# Establecer conexion a base de datos
engine = create_engine("mysql+mysqldb://root:Maripau01@localhost/sigmaa")

# Almacenar la oferta academica en la base de datos
for df in range(1, len(dfs)):
    if df == 1:
        dfs[df].to_sql('secciones_170300075', con = engine, if_exists='replace')
    else:
        dfs[df].to_sql('secciones_170300075', con = engine, if_exists='append')

logout = driver.find_element(By.XPATH, '/html/body/div[2]/div/form/a')
logout.click()

driver.quit()