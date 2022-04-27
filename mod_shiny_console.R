## Emulate an R console inside a shiny app. 
## Press enter to execute the code while writing inside the textInput
## or click the send button


mod_console_ui <- function(id) {
  ns <- NS(id)
  tagList(
    textInput(ns("console"), "Type your code:", value = ""),
    actionButton(ns("send"), "Send code:"),
    verbatimTextOutput(ns("console_output")),
    nter::nter(ns("send"), ns("console"))
  )
}

mod_console_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    observeEvent(input$send, {
      output$console_output <- renderPrint({
        purrr::safely(~ eval(parse(text = isolate(input$console))))() %>%
          purrr::compact() %>%
          `[`(1)
      })
    })
  })
}

## To be copied in the UI
# mod_console_ui("console_1")

## To be copied in the server
# mod_console_server("console_1")
