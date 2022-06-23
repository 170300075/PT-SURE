matriculaInput <- function(inputId, label, value = NULL) {
    tagList(
        shiny::singleton(
            shiny::tags$head(
                shiny::tags$script(src = "matriculaInput-binding.js"),
                shiny::tags$script(src = "bootstrap.bundle.min.js"),
                shiny::tags$link(rel = "stylesheet", type="text/css", href="matricula-style.css"),
                shiny::tags$link(rel = "stylesheet", type="text/css", href="bootstrap.min.css")
            )
        ),

        shiny::tags$div(
            class = "form-floating mb-4",

            
            shiny::tags$input(id = inputId, type = "number", class = "form-control", "onKeyPress"="if(this.value.length==9) return false;", placeholder = "Matricula", value = value),
            shiny::tags$label(label, "for" = inputId)
        )
    )
}

updateMatriculaInput <- function(session, inputId, label = NULL, value = NULL) {
    message <- dropNulls(
        list(
            label = label,
            value = value
        )
    )

    session$sendInputMessage(inputId, message)
}

dropNulls <- function(x) {
    x[!vapply(x, is.null, FUN.VALUE=logical(1))]
}
