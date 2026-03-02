class TweetsController < ApplicationController
  def new
    @tweet = Tweet.new
  end

  def create
    # create the instance of Ruby LLM (Chat)
    chat = RubyLLM.chat
    # We receive the params of the form into an instance of tweet(long)
    tweet = Tweet.new(tweet_params)
    # We use our chat instance to shorten the tweet
    tweet.shortened = chat.ask("Generate a tweet from this text: #{tweet.long}").content
    if tweet.save
      redirect_to tweet_path(tweet), notice: "Tweet was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  def index
    @tweets = Tweet.all
  end

  private

  def tweet_params
    params.require(:tweet).permit(:long)
  end
end
