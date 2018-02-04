library(twitteR)

api_key <- "your_own_api"
api_secret <- "your_own_api"
access_token <- "your_own_api"
access_token_secret <- "your_own_api"

#setting up api
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

#searching 2000 tweets about with AdmiralBulldog
bulldog_tweet = searchTwitter("AdmiralBulldog", n =2000, lang = "en")

#looking at the structure of the tweet
length(bulldog_tweet)

#first five tweets
head(bulldog_tweet, 5)

#getting the text
bulldog_tweet <- sapply(bulldog_tweet,function(x) x$getText())

#remove the NAs in the tweets
bulldog_tweet_cleaned = cleanTweetsAndRemoveNAs(bulldog_tweet)
length(bulldog_tweet_cleaned)

#getting the  sentiment score of the tweets
bulldog_result = getSentimentScore(bulldog_tweet_cleaned, words.negative, words.positive)

#classify the polarity of the tweets
bulldog_tweet_emo = classify_emotion(bulldog_tweet_cleaned, algorithm = "bayes", prior = 1.0)

#renaming the emotions
bulldog_tweet_emotion = bulldog_tweet_emo[,7]
bulldog_tweet_emotion[is.na(bulldog_tweet_emotion)] = "unknown"

#identify the polarity
bulldog_tweet_pol = classify_polarity(bulldog_tweet_cleaned, algorithm = 'bayes')
bulldog_pol = bulldog_tweet_pol[,4]

#data frame the text
bulldog_tweet_DataFrame = data.frame(text=bulldog_tweet_cleaned, emotion=bulldog_tweet_emotion, polarity=bulldog_pol, stringsAsFactors=FALSE)

#factoring the tweets
bulldog_tweet_DataFrame = within(bulldog_tweet_DataFrame, emotion <- factor(emotion, levels=names(sort(table(emotion), decreasing=TRUE))))

#plot the polarity
plotSentiments2(bulldog_tweet_DataFrame, "Polarity Analysis of Tweets on Twitter about AdmiralBulldog")

#get the word clouds
getWordCloud(bulldog_tweet_DataFrame, bulldog_tweet_cleaned, bulldog_tweet_emotion)
