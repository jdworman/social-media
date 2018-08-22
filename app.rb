require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/cookies'
enable :sessions

require 'active_record'
require 'will_paginate'
require 'will_paginate/active_record'


set :database, 'sqlite3:social-media.sqlite3'
# ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])

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
  redirect '/new'
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
    flash[:info] = "You have successfully logged in, <%= session[:user].firstname %>."
  else
        flash[:warning] = 'Invalid username or password.'
    redirect '/login'
  end
end

get '/account' do
  erb :account
end

get '/profile' do
  erb :profile
end

get '/profile/:id' do
  begin
  @posts = Post.all.order(datetime: :desc).limit(20).offset(params[:page])
    @paginate = Post.paginate(:page => params[:page], :per_page => 20)
  rescue
    @posts = nil
  end
  erb :profile
end

get '/setting' do
  erb :Setting
end

get '/logout' do
  session.clear
  response.set_cookie("user", :value => "")
  flash[:notice] = 'You have been signed out.'
  redirect '/'
end

get '/post' do
    @user = session[:user]
  erb :post
end
post '/post' do
	post = Post.new(
    title: params['title'],
    content: params['content'],
    firstname:session[:user].firstname,
    lastname:session[:user].lastname,
    image_url:session['image_url']
  )
  post.save
	redirect '/'
end

post '/birthday' do
  params
end

get '/new' do
  erb :new
end

post '/posts' do
  erb :posts
end


post '/delete' do
  User.where(email: session[:user][:email]).destroy_all
  session.clear
  response.set_cookie("user", :value => "")
  redirect '/'
end

get '/*' do
  erb :unknown
end

# Verify authenticity of user
def CheckAuth()
  # Get the cookie/session
  user = request.cookies["user"]
  if user.nil?
    if session[:user].nil?
      # flash[:notice] = "Cookie/Session does NOT exist"
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
      # flash[:notice] = "Cookie user could not be found in DB"
      return check
    else
      return true
    end
  end
end

require './models'
