---
title: "Homework6"
author: "Bibek Gupta"
date: "5/6/2020"
output: Homework6.R
runtime: shiny
---
  
  1.

```{r}
library(shiny)
ui <- fluidPage(headerPanel(" Hello!!!!"), numericInput("abc","Enter input:",30,min = 1, max = 30),
                plotOutput("hist")
)

server <- function(input, output){
  output$hist = renderPlot({
    title = "Histogram"
    hist(rpois(input$abc,lambda = 9), main = title)
  })
}

shinyApp(ui = ui, server = server)
```

2.

```{r}
library(car)
data(Soils)

ui <- fluidPage(
  
  headerPanel(" Hello!!! "),
  
  sidebarPanel(
    selectInput("xvar", label = "Select X variable:", names(Soils)[6:14],
                selected = names(Soils)[9]),
    selectInput("yvar", label = "Select Y variable:", names(Soils)[6:14],
                selected = names(Soils)[11])
  ),
  
  mainPanel(
    plotOutput("scatter"),
    
    "Summary output:",
    
    verbatimTextOutput("cor")
  )
)

server <- function(input, output){
  
  selectedData <- reactive({
    Soils[, c(input$xvar, input$yvar)]
  })
  
  output$scatter <- renderPlot({
    plot(selectedData())
  })
  
  output$cor <- renderPrint({
    summary(selectedData())
  })
}

shinyApp(ui = ui, server = server)
```

3.

```{r}
library(shiny)

ui <- fluidPage(
  
  titlePanel("One User Input and One Reactive Input"),
  
  sidebarLayout(
    
    sidebarPanel(
      textInput(inputId = "caption",
                label = "CAPTION:",
                value = "Bibek Gupta"),
      
      selectInput(inputId = "dataset",
                  label = "CHOOSE A DATASET: ",
                  choices = c("rock", "pressure", "cars")),
      
      numericInput(inputId = "obs",
                   label = "NUMBER OF OBSERVATIONS PER VIEW: ",
                   value = 10)
      
    ),
    
    mainPanel(
      
      h3(textOutput("caption", container = span)),
      
      verbatimTextOutput("summary"),
      
      tableOutput("view")
      
    )
  )
)

server <- function(input, output) {
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars)
  })
  
  output$caption <- renderText({
    input$caption
  })
  
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
  
}

shinyApp(ui, server)
```
