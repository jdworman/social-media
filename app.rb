require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/reloader'
enable :sessions
require './models'

set :database, 'sqlite3:rumblr.sqlite3'

get '/home' do
  erb :home
end

get '/' do
  @user = User.all
  p @users
  erb :home
end

get '/signup' do
  erb :signup
end

post '/signup' do
  email = params[:email]
  password = params[:password]
  reenter_password = params[:reenter_password]
  firstname = params[:firstname]
  lastname = params[:lastname]
  birthday = params[:birthday]
end

get '/login' do
  erb :login
end


post '/login' do
  email = params['email']
  given_password = params['password']

  user =  User.find_by(email: email)
  if user.password == given_password
    session[:user] = user
    redirect :account
    flash[:info] = "You have successfully logged in, #{@user.firstname}."
  else
        flash[:warning] = 'Invalid username or password.'
    redirect '/login'
  end
end




get '/account' do
  erb :account
end


get '/logout' do
  session[:user] = nil
  flash[:notice] = 'You have been signed out.'
  redirect '/'
end

get '/setting' do
  erb :Setting
end

get '/profile' do
  erb :profile
end
