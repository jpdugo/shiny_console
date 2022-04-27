
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shiny_console

<!-- badges: start -->
<!-- badges: end -->

Execute R code from inside a shiny app.

# usage

``` r
library(shiny)
library(magrittr)

# remotes::install_github("JohnCoene/nter")

## Emulate an R console inside a shiny app. 
## Press enter to execute the code while writing inside the textInput
## or click the send button

ui <- fluidPage(
  mod_console_ui("console_1")
)

server <- function(input, output, session) {
  mod_console_server("console_1")
}

shinyApp(ui, server)
```
