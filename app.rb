require 'rubygems'
require 'sinatra'
#require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "leprosorium.db"}

class Post < ActiveRecord::Base
   has_many :comments, dependent: :destroy
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

get '/' do
    @posts = Post.all
    erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  c = Post.new params[:post]
  c.save

  redirect to '/'
end

get '/details/:post_id' do
  @posts = Post.find(params[:post_id])
  a = params[:post_id]
  @comments = Comment.where(post_id: a)
  
  erb :details
end

post '/details/:post_id' do
  c = Comment.new params[:comment]
  c.save

  @posts = Post.find(params[:post_id])
  a = params[:post_id]
  @comments = Comment.where(post_id: a)
  
  erb :details
end