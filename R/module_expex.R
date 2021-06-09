#' UI Export excel to symbol separated file
#'
#' @param id session id
#' @export
excel_exporter_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::pageWithSidebar(
        shiny::headerPanel(NULL),
        shiny::sidebarPanel(
            width = 3,
            shiny::sliderInput(
                inputId = shiny::NS(id, "sheet"),
                label = shiny::h4("Choose sheet number"),
                min = 1,
                max = 10,
                value = 1
            ),
            shinyWidgets::pickerInput(
                inputId = shiny::NS(id, "delimeter"),
                label = shiny::h4("Choose separator"),
                choices = c(
                    "commas" = ",",
                    "semicolons" = ";",
                    "tabs" = "\t",
                    "spaces" = " "
                ),
                selected = ","
            ),
            shiny::textInput(
                inputId = shiny::NS(id, "file_name"),
                label = shiny::h4("Choose file name"),
                value = "Enter text..."
            ),
            shiny::fileInput(
                inputId = shiny::NS(id, "target_load"),
                label = shiny::h4("Choose excel"),
                accept = c(".xls", ".xlsx"),
                placeholder = "No file selected",
                buttonLabel = "Browse...",
                width = 400
            ),
            shiny::downloadButton(
                outputId = shiny::NS(id, "export"),
                label = "Download delimited file",
                icon = shiny::icon("table")
            )
        ),
        shiny::mainPanel(
            shiny::column(
                width = 12,
                shiny::h3("Uploaded data"),
                DT::dataTableOutput(shiny::NS(id, "loaded"))
            )
        )
    )
}

#' Server Export excel to symbol separated file
#'
#' @param id session id
#' @export
excel_exporter_server <- function(id) {
    shiny::moduleServer(id, function(input, output, session) {

        df_loaded <- shiny::reactive({
            shiny::req(inFile <- input$target_load, input$sheet)
            if (is.null(inFile)) { return(NULL) }
            df <- readxl::read_excel(inFile$datapath, col_names = TRUE, sheet = input$sheet)
        })

        output$loaded <- DT::renderDataTable({
            df_loaded() %>%
                DT::datatable(
                    escape = FALSE,
                    rownames = FALSE,
                    extensions = "Scroller",
                    options = list(
                        deferRender = TRUE,
                        scrollY = "40vh",
                        scrollX = TRUE,
                        scroller = TRUE
                    )
                )
        })


        output$export <- shiny::downloadHandler(
            filename <- function() {
                glue::glue("{input$file_name}.csv")
            },
            content <- function(file) {
                readr::write_delim(x = df_loaded(), file = file, delim = input$delimeter)
            }
        )
    })
}



















