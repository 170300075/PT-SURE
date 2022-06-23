contraseñaInput <- function(inputId, label, value = NULL) {
    tagList(
        shiny::singleton(
            shiny::tags$head(
                shiny::tags$script(src = "contraseñaInput-binding.js"),
                shiny::tags$script(src = "bootstrap.bundle.min.js"),
                shiny::tags$link(rel = "stylesheet", type="text/css", href="bootstrap.min.css")
            )
        ),

        shiny::tags$div(
            class = "form-floating mb-4",

            
            shiny::tags$input(id = inputId, type = "password", class = "form-control", placeholder = "Contraseña", value = value),
            shiny::tags$label(label, "for" = inputId)
        )
    )
}

updateContraseñaInput <- function(session, inputId, label = NULL, value = NULL) {
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
