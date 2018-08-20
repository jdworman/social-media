require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/reloader'
enable :sessions
require './models'

set :database, 'sqlite3:rumblr.sqlite3'

get '/' do
  p 'we did it!'
  @user = User.all
  p @users
  erb :home
end

get '/login' do
  erb :login
end

post '/login' do
   @email = params[:email],
   @password = params[:password]
   # p "your account name is #{params['email']}"
   # p "your account name is #{params['password']}"
   redirect :account
end

get '/account' do
  erb :account
end

get '/signup' do
  erb :signup
end

get '/home' do
  erb :home
end

post '/signup' do
  p params

  user = User.new(
    email: params['email'],
    name: params['name'],
    password: params['password']
  )
  user.save
  redirect '/'
end

post '/login' do
  email = params['email']
  given_password = params['password']
  # check is email exists
  # check to see if the email has a password == form PASSWORD
  # if match, login user
  user = User.find_by(email: email)
  if user.password == given_password
    session[:user] = user
    redirect :account
  else
    p 'wrong credentials'
    redirect '/'
 end
end

get '/logout' do
  session[:user] = nil
  p 'user has logged out'
  redirect '/'
end

require './models'
