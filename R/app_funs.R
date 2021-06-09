#' App UI
#'
#' @export
#' @include module_expex.R
ui <- function() {
    shiny::shinyUI(
        shiny::navbarPage(
            theme = shinythemes::shinytheme("flatly"),
            title = "expex",
            id = "tabs",
            shiny::tabPanel(
                title = "Excel exporter",
                value = "tab_1",
                excel_exporter_ui("tab1")
            )

        )
    )
}

#' App server
#'
#' @export
server <- function() {
    function(input, output, session) {
        excel_exporter_server("tab1")
    }
}
