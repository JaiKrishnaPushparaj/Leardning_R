library(twitteR) ### for fetching the tweets
library(plyr) ## for breaking the data into manageable pieces
library(ROAuth) # for R authentication
library(stringr) # for string processing
library(ggplot2) # for plotting the results
appname <- "JKDataCollection"
key <- "YSGgv1DUrhQUWYyL82Svx5wlj"
secret <- "eJWjFkWarSPe3AnwNYNf5GzTOcW848JNokRwxdWrgCKk9gMVV6"
access_token <- "1173902450081685504-Mi5k73EMSmA5p4tKf69sRPjacndB36"
access_secret <- "qv3RpVhiJIF3PSiqDKjLXS13uklXSofb2mY3u7PSt1vca"
setup_twitter_oauth(api_key,api_secret,access_token,access_secret)
posText <- read.delim("C:\\Users\\Administrator\\Desktop\\positive-words.txt", header=FALSE, stringsAsFactors=FALSE)
posText <- posText$V1
posText <- unlist(lapply(posText, function(x) { str_split(x, "\n") }))
negText <- read.delim("C:\\Users\\Administrator\\Desktop\\negative-words.txt", header=FALSE, stringsAsFactors=FALSE)
negText <- negText$V1
negText <- unlist(lapply(negText, function(x) { str_split(x, "\n") }))
pos.words = c(posText, 'upgrade')
neg.words = c(negText, 'wtf', 'wait', 'waiting','epicfail', 'mechanical')
search_tweets = searchTwitter('#nba', n=50)
search_txt = sapply(search_tweets, function(t) t$getText() )
searcher<- c(search_txt)
score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  # Parameters
  # sentences: vector of text to score
  # pos.words: vector of words of positive sentiment
  # neg.words: vector of words of negative sentiment
  # .progress: passed to laply() to control of progress bar
  # create a simple array of scores with laply
  scores = laply(sentences,
                 function(sentence, pos.words, neg.words)
                 {
                   # remove punctuation
                   sentence = gsub("[[:punct:]]", "", sentence)
                   # remove control characters
                   sentence = gsub("[[:cntrl:]]", "", sentence)
                   # remove digits?
                   sentence = gsub('\\d+', '', sentence)
                   # define error handling function when trying tolower
                   tryTolower = function(x)
                   {
                     # create missing value
                     y = NA
                     # tryCatch error
                     try_error = tryCatch(tolower(x), error=function(e) e)
                     # if not an error
                     if (!inherits(try_error, "error"))
                       y = tolower(x)
                     # result
                     return(y)
                   }
                   # use tryTolower with sapply
                   sentence = sapply(sentence, tryTolower)
                   # split sentence into words with str_split (stringr package)
                   word.list = str_split(sentence, "\\s+")
                   words = unlist(word.list)
                   # compare words to the dictionaries of positive & negative terms
                   pos.matches = match(words, pos.words)
                   neg.matches = match(words, neg.words)
                   # get the position of the matched term or NA
                   # we just want a TRUE/FALSE
                   pos.matches = !is.na(pos.matches)
                   neg.matches = !is.na(neg.matches)
                   # final score
                   score = sum(pos.matches) - sum(neg.matches)
                   return(score)
                 }, pos.words, neg.words, .progress=.progress )
  # data frame with scores for each sentence
  scores.df = data.frame(text=sentences, score=scores)
  return(scores.df)
}
scores = score.sentiment(searcher, pos.words,neg.words , .progress='text')
scores$positive <- as.numeric(scores$score >0)
scores$negative <- as.numeric(scores$score <0)
scores$neutral <- as.numeric(scores$score==0)
search_searcher<- subset(scores, scores$searcher=="search")
search_searcher$polarity <- ifelse(search_searcher$score >0,"positive",ifelse(search_searcher$score < 0,"negative",ifelse(search_searcher$score==0,"Neutral",0)))
qplot(factor(polarity), data=search_searcher, geom="bar", fill=factor(polarity))+xlab("Polarity Categories") + ylab("Frequency") + ggtitle("Sentiments")
