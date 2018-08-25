require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/cookies'
require 'date'
enable :sessions

require 'active_record'


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
    birthday: params['birthday']
  )
  user.save
  session[:user] = user
  response.set_cookie('user',
                      value: user[:email], # not secure
                      domain: '',
                      path: '',
                      expires: Time.now + 3600 * 24)
  redirect :new
end

get '/login' do
  erb :login
end

post '/login' do
  email = params['email']
  given_password = params['password']
  user = User.find_by(email: email)
  if user.password == given_password
    session[:user] = user
    response.set_cookie('user',
                        value: user[:email], # not secure
                        domain: '',
                        path: '',
                        expires: Time.now + 3600 * 24)
    redirect :allposts
    flash[:info] = 'You have successfully logged in, <%= session[:user].firstname %>.'
  else
    flash[:warning] = 'Invalid username or password.'
    redirect :login
  end
end

get '/profile' do
  erb :profile
end


get '/users/:id' do
  @maker = User.find(params[:id])
  erb :users
end

get '/account' do
    # session[:user].id = params[:id]
   # @posts = @account.posts
 erb :account
end
get '/setting' do
  erb :setting
end

get '/logout' do
  session.clear
  response.set_cookie('user', value: '')
  flash[:notice] = 'You have been signed out.'
  redirect :home
end



get '/post' do
  @user = session[:user]
    @allmessages = Post.all
  erb :post
end

post '/post' do
  post = Post.new(
    title: params['title'],
    content: params['content'],
    image_url: session['image_url'],
    user_id: session[:user].id
  )
  post.save
  redirect :allposts
end

post '/birthday' do
  params
end

get '/new' do
  erb :new
end

get '/allposts' do
  erb :allposts
end

post '/delete' do
  User.where(email: session[:user][:email]).destroy_all
  session.clear
  response.set_cookie('user', value: '')
  redirect :home
end

get '/*' do
  erb :unknown
end



# Verify authenticity of user
def CheckAuth
  # Get the cookie/session
  user = request.cookies['user']
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

require './models'
