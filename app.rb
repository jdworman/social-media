require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/reloader'
require 'sinatra/cookies'
enable :sessions
require './models'

set :database, 'sqlite3:rumblr.sqlite3'

# Verify authenticity of user
def CheckAuth()
  # Get the cookie/session
  user = request.cookies["user"]
  if user.nil?
    if session[:user].nil?
      flash[:notice] = "Cookie/Session does NOT exist"
      return false
    else
      return true
    end
  else
    check = false
    @dbusers = User.all # efficient?
    for u in @dbusers do
      if u[:email] == user
        check = true
        session[:user] = u
      end
    end
    if check == false
      flash[:notice] = "Cookie user could not be found in DB"
      return check
    else
      return true
    end
  end
end

get '/home' do
  erb :home
end

get '/' do
  @user = User.all
  p @users
  check = CheckAuth()
  erb :home
end

get '/signup' do
  erb :signup
end

post '/signup' do
  user = User.new(
    email: params[:email],
    password: params[:password],
    firstname: params[:firstname],
    lastname: params[:lastname],
    birthday: params[:birthday]
  )
  user.save
  session[:user] = user
  response.set_cookie("user",
    :value => user[:email], # not secure
    :domain => "",
    :path => "",
    :expires => Time.now + 3600*24)
  redirect '/account'
end

get '/login' do
  erb :login
end

post '/login' do
  user = User.find_by(email: params['email'])
  if user.password == params['password']
    session[:user] = user
    response.set_cookie("user",
      :value => user[:email], # not secure
      :domain => "",
      :path => "",
      :expires => Time.now + 3600*24)
    redirect '/account'
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
  session.clear
  response.set_cookie("user", :value => "")
  flash[:notice] = 'You have been signed out.'
  redirect '/'
end

get '/setting' do
  erb :Setting
end

get '/profile' do
  erb :profile
end

post '/delete' do
  User.where(email: session[:user][:email]).destroy_all
  session.clear
  response.set_cookie("user", :value => "")
  redirect '/'
end
