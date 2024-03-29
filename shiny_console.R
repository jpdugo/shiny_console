box::use(
  purrr,
  shiny[...],
  shinyjs[...],
  glue[glue],
  stringr[str_extract]
)

#' Emulate an R console inside a shiny app
#'
#' This module allows for running R code interactively inside a shiny app.
#' The user can execute the code by pressing enter while writing inside the textInput
#' or by clicking the send button.
#'
#' @name mod_console
#'
#' @param id Module's id.
#'
#' @return The user interface of the R console module.
#' @export
#' @examples
#' \dontrun{
#' box::use(
#'   shiny[...],
#'   shinyjs
#' )
#' ui <- fluidPage(
#'   shinyjs$useShinyjs(),
#'   shiny_console$ui("console_1")
#' )
#' server <- function(input, output, session) {
#'   shiny_console$server("console_1")
#' }
#' shinyApp(ui, server)
#' }
ui <- function(id) {
  ns <- NS(id)
  tagList(
    textInput(
      inputId = ns("console"),
      label   =  "Type your code:",
      value   = ""
    ),
    actionButton(
      inputId = ns("send"),
      label   = "Send code:"
    ),
    verbatimTextOutput(ns("console_output"))
  )
}


#' @param id
#'
#' @return A module server function for executing the R code.
#' @export
#'
#' @rdname mod_console
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observe({
      runjs(
        glue(
          '$("#{ns("console")}").keyup(function(event) {{
             if (event.keyCode === 13) {{
               $("#{ns("send")}").click();
             }}
           }});'
        )
      )
    })

    out <- eventReactive(input$send, {
      purrr$safely(
        .f = ~ eval(parse(text = input$console), envir = .GlobalEnv)
      )() |>
        (\(x) {
          if (is.null(x$result)) {
            x$error |>
              as.character() |>
              str_extract(": (.*)", group = 1)
          } else {
            x$result
          }
        })()
    })

    output$console_output <- renderPrint({
      out()
    })
  })
}