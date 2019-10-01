library(rtweet)
library(ROAuth)
library(ggplot2)
library(dplyr)
library(tidytext)
library(RCurl)
library(tm)
library(igraph)
library(ggraph)
library(shiny)
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
server<- function(input, output){
  users <- search_tweets(q = input$search,n=as.numeric(input$n),lang = "en",include_rts = FALSE )
  users$stripped_text <- gsub("http.*","",  users$text)
  users$stripped_text <- gsub("https.*","", users$stripped_text)
  users_clean <- users%>%
    dplyr::select(stripped_text) %>%
    unnest_tokens(word, stripped_text)
  dm <- reactive({
    dm <- users(input$search, as.numeric(input$n))
  })
 output$displot<-reactivePlot( renderPlot(
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
 )
  )
}
