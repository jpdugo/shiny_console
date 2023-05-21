
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shiny_console

<!-- badges: start -->
<!-- badges: end -->

Execute R code from inside a shiny app.

# usage

``` r
box::use(
  ./shiny_console,
  shiny[...],
  shinyjs
)

ui <- fluidPage(
  shinyjs$useShinyjs(),
  shiny_console$ui("console_1")
)

server <- function(input, output, session) {
  shiny_console$server("console_1")
}

shinyApp(ui, server)
```
