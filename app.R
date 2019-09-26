#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(rtweet)
library(ggplot2)
library(dplyr)
library(tidytext)
library(igraph)
library(ggraph)
library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            textInput("Search",h3("Search For"),value = ""),
            sliderInput("tweets", 
                        label="Select Number of Tweets",
                        min=10, max=50, value=15)
        ),
    

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
users <- function(input, output) {
    appname <- "JKDataCollection"
    key <- "YSGgv1DUrhQUWYyL82Svx5wlj"
    secret <- "eJWjFkWarSPe3AnwNYNf5GzTOcW848JNokRwxdWrgCKk9gMVV6"
    access_token <- "1173902450081685504-Mi5k73EMSmA5p4tKf69sRPjacndB36"
    access_secret <- "qv3RpVhiJIF3PSiqDKjLXS13uklXSofb2mY3u7PSt1vca"
    twitter_token <- create_token(
        app = appname,
        consumer_key = key,
        consumer_secret = secret,
        access_token = access_token,
        access_secret = access_secret)
    users< - search_tweets(q = "#modi",n = 100,lang = "en",include_rts = FALSE )
    length(unique(users$location))
    users %>%
        ggplot(aes(location)) +
        geom_bar() + coord_flip() +
        labs(x = "Count",
             y = "Location",
             title = "Twitter users - unique locations ")
    users %>%
        count(location, sort = TRUE) %>%
        top_n(10)%>%
        mutate(location = reorder(location,n)) %>%
        na.omit() %>%
        ggplot(aes(x = location,y = n)) +
        geom_col() +
        coord_flip() +
        labs(x = "Location",
             y = "Count",
             title = "Twitter users - unique locations ") 
    
    users$stripped_text <- gsub("http.*","",  users$text)
    users$stripped_text <- gsub("https.*","", users$stripped_text)
    users_clean <- users%>%
        dplyr::select(stripped_text) %>%
        unnest_tokens(word, stripped_text)
    users_clean %>%
        count(word, sort = TRUE) %>%
        top_n(9) %>%
        mutate(word = reorder(word, n)) %>%
        ggplot(aes(x = word, y = n)) +
        geom_col() +
        xlab(NULL) +
        coord_flip() +
        labs(x = "Count",
             y = "Unique words",
             title = "Count of unique words found in tweets")
    

}

# Run the application 
shinyApp(ui = ui, server = users)
