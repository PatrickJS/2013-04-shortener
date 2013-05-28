require 'sinatra'
require "sinatra/reloader" if development?
require 'active_record'
require 'pry'
require 'json'

configure :development, :production do
  ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database =>  'db/dev.sqlite3.db'
  )
end

class Link < ActiveRecord::Base
end


get '/' do
  erb :index
end

get '/assets/javascript/:file' do
  send_file "assets/javascript/#{params[:file]}"
end

get '/get/:id' do
  id = params[:id]
  link = Link.find(id)
  return link.clicks.to_s
end

get '/assets/lib/:file' do
  send_file "assets/lib/#{params[:file]}"
end

get '/assets/stylesheets/:file' do
  send_file "assets/stylesheets/#{params[:file]}"
end

get '/:id' do
  id = params[:id]
  if Link.exists?(id)
    link = Link.find(id)
    Link.update(id, :clicks => link.clicks+=1);

    redirect "http://#{link.url}"
  else
    halt 404, 'page not found'
  end
end


post '/new' do
  link = Link.where(
      :url => params[:url]
    ).first_or_create(
      :clicks => 0
    )
  ActiveRecord::Base.connection.close
  # "localhost:4567/#{link.id}"
  link.to_json
end
