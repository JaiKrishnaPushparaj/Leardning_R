library(shiny)
ui<- fluidPage(
    titlePanel("TWITTER ANALYSIS"),
    sidebarLayout(
      sidebarPanel(
        textInput(inputId = "search",h4("SEARCH FOR")
        ),
        sliderInput(inputId = "n",
                    label = "Number of Tweets:",
                    min = 1,
                    max = 50,
                    value = 30)
      ),
    mainPanel("main Panel")
)
)