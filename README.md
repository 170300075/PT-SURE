# PT-SURE
MIRO: https://miro.com/welcome/TXFkR1lqdlJtOTZnSzV0dDVaNTFZZDZQYnNZT1lJaDVQZmlMWTNaRFNYWXBiRnRZVlY0Mm4waUMyV1FBd0tjb3wzNDU4NzY0NTI3Njk0NDYxMDAw?share_link_id=170334272160

<h2 style="color: lightblue; text-align: center">Repositorio del proyecto terminal</h2>

## Instrucciones de instalación de ambiente de trabajo

Para poder empezar a trabajar en el documento es necesario tener instalado las siguientes herramientas de desarrollo:

### *Si estás en windows*

- R
- RStudio
- Rtools
- Python3
- Jupyter notebook/lab
- Edge Driver / Chrome Driver (dependiendo de qué navegador prefieras)
- Git
- VSCode
- XAMPP Server

### *Bibliotecas*

Dentro de **R**:

- shiny
- bs4Dash
- DBI
- RMariaDB
- highcharter
- reticulate
- shinyWidgets

Dentro de **Python**:

- pandas
- numpy
- selenium

# Objetivos del dashboard

## Progreso personal

El tablero debe permitir visualizar el mapa curricular con las asignaturas que los alumnos tienen que cursar. Estas asignaturas deben estar coloreadas dependiendo del estatus entre los cuales se encuentran: `Cursando`, `Aprobada`, `Reprobada`, `Pendiente`.

- `Cursando`: Las asignaturas de este rubro son aquellas que el estudiante matriculó en el semestre en curso.

- `Aprobada`: Son aquellas asignaturas que el estudiante ha cursado en semestres anteriores y que alcanzaron la calificación mínima aprobatoria.

- `Reprobada`: Se trata de las asignaturas que fueron reprobadas en semestres anteriores y por tanto, se volverion obligatorias para la siguiente selección de asignaturas.

- `Pendiente`: Todas las asignaturas que no se han matriculado en ningún semestre.

En este apartado se debe poder comprender cuales son las materias que hacen falta por terminar echando un vistazo general en el mapa.

## Estadísticas

Otra funcionalidad que se debe implementar, es representar a traves de gráficas información relacionada con los indicadores de reindimiento académico. Algunos de esos indicadores son:

- Créditos obtenidos por ciclo escolar
- Tiempo de permanencia
- Promedio semestral histórico

## Balance

Cada estudiante debe disponer de la información de sus adeudos y pagos históricos. Esta información es proporcionada en forma de tablas. Se propone agregar una gráfica que permita al usuario visualizar el dinero que ha invertido en su educación a lo largo de su vida estudiantil.

Este apartado debe tener las siguientes funcionalidades

- Mostrar la tabla de adeudos
- Proporcionar el PDF descargable para pagar un adeudo existente
- Permitir subir una imagen del recibo de pago y reportar que el sistema no ha actualizado esta información en caso de que SIGMAA reporte que el saldo no fue pagado

## Mi horario

## Desempeño docente

Cada semestre, despues del primer parcial, la universidad permite a los estudiantes realizar una encuesta para evaluar el desempeño de sus profesores. Las evaluaciones constan de un formulario con multiples preguntas que pueden ser contestadas a traves de:

- Botones de selección dividual como `Radio buttons`
- Escribir feedback a traves de campos de texto como `Text area`