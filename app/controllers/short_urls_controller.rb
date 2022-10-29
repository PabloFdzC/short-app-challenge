class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  # index returns a list with a json object
  # with an attribute urls, this attribute
  # has a list with objects with id, full_url,
  # short_code and click_count
  # I know that test is not passed, but I am
  # not sure how it is expected to be sent
  def index
    @shortUrls = ShortUrl.select(["id","full_url", "short_code", "click_count"]).order(click_count: :desc).limit(100)
    render json: {"urls":@shortUrls}
  end

  def create
    @shortUrl = ShortUrl.create(full_url: params[:full_url])
    if @shortUrl.valid?
      render json: @shortUrl
    else
      render json: {
        errors: @shortUrl.errors[:full_url]
      }
    end
  end

  def show
    puts params[:id]
    @shortUrl = ShortUrl.where(short_code: params[:id]).first
    if @shortUrl.nil?
      render :nothing => true, :status => 404
    else
      url = @shortUrl.increase_count
      redirect_to url
    end
  end

  

end
