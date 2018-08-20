require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/reloader'
enable :sessions
require './models'

set :database, 'sqlite3:rumblr.sqlite3'

get '/login' do
  erb :login
end

post '/login' do
  email = params['email']
  given_password = params['password']
  user = User.find_by(email: email)
  if user.password == given_password
    session[:user] = user
    redirect :account
  else
    flash[:notice] = 'You could not be signed in. Did you enter the correct username and password?'
    redirect '/signin'
 end
end

post '/signin/?' do
  if user = User.authenticate(params)
    session[:user] = user
    redirect_to_original_request
  else
    flash[:notice] = 'You could not be signed in. Did you enter the correct username and password?'
    redirect '/signup'
  end
end

get '/' do
  p 'we did it!'
  @user = User.all
  p @users
  erb :home
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
    firstname: params['firstname'],
    lastname: params['lastname'],
    password_hash: params['password']
  )
  user.save
  redirect '/'
end


get '/logout' do
  session[:user] = nil
  flash[:notice] = 'You have been signed out.'
  redirect '/'
end

get '/setting' do
  erb :setting
end
