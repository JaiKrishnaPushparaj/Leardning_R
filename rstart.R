library(rtweet)
library(ggplot2)
library(dplyr)
library(tidytext)
library(igraph)
library(ggraph)
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
rstats_tweets <- search_tweets(q = "BigilAUdioLanch",n = 10,lang = "en", )
print(rstats_tweets$text)