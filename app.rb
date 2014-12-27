require 'sinatra'
require 'csv'

def read_articles_from(filename)
  articles = []

  CSV.foreach(filename, headers: true) do |row|
    articles << {
      title: row['title'],
      description: row['description'],
      url: row['url']
    }
  end

  articles
end

def save_article(filename, title, description, url)
  CSV.open(filename, 'a') do |csv|
    csv << [title, description, url]
  end
end


get '/' do

redirect '/articles'
end

get '/articles' do
@articles = read_articles_from('articles.csv')
erb :articles
end

get '/articles/new' do

erb :submit_new_articles

end


post '/articles' do
  @title = params[:article][:title]
  @description = params[:article][:description]
  @url = params[:article][:url].chomp
  # array = []
  # @articles.each do |check_submitted|
  #   array << check_submitted[:article][:url]
  # end

  if !params[:article][:title].empty? &&
     params[:article][:description].length >= 10 &&
     !params[:article][:url].empty? &&
    #  !array.include?(params[:article][:url])
        save_article('articles.csv', @title, @description, @url)

  redirect '/articles'

  else
    @error_messages = []
    @error_messages << "You must enter a name." if params[:article][:title].empty?
    @error_messages << "Description must be 10 characters or longer." if params[:article][:description].length < 10
    @error_messages << "You must enter a URL." if params[:article][:url].empty?
    # @error_messages << "You have entered a duplicate URL." if array.include?(params[:article][:url])

  erb :submit_new_articles
  end
end
