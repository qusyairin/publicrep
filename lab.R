library(shiny)

ui <- fluidPage(
  titlePanel("Shiny Text"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId= "dataset", label = "Choose a dataset:",
                  choices = c("Human", "Abalone", "Iris", "Heart")),
      numericInput(inputId = "obs",
                   label = "Number of observations to view:",
                   value = 10)
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotOutput("plot")),
                  tabPanel("Summary", verbatimTextOutput("summary")),
                  tabPanel("Table", tableOutput("view"))
      )
    )
  )
)

server <- function(input, output) {
  
  Human <- read.csv('human.csv', stringsAsFactors = FALSE)
  Abalone <- read.csv('abalone.csv', stringsAsFactors = FALSE)
  Iris <- read.csv('iris.csv', stringsAsFactors = FALSE)
  Heart <- read.csv('heart.csv', stringsAsFactors = FALSE, header = TRUE)

  datasetInput <- reactive({
    switch(input$dataset,
           "Human"=Human$Weight,
           "Abalone" = Abalone$Height,
           "Iris" = Iris$SepalLengthCm,
           "Heart"= Heart$trestbps)
  })
  
  datasetInput2 <- reactive({
    switch(input$dataset,
           "Human"=Human,
           "Abalone" = Abalone,
           "Iris" = Iris,
           "Heart"= Heart)
  })
  
  output$plot <- renderPlot({
    hist(datasetInput())
  })
  
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  
  output$view <- renderTable({
    head(datasetInput2(), n = input$obs)
  })
    
  }




shinyApp(ui = ui, server = server)