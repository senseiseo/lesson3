require 'sinatra'
require 'sqlite3'
require 'sinatra/reloader'


# Method connect with database
def get_db
  db = SQLite3::Database.new 'base.db'
  db.results_as_hash = true
  return db
end

# Configure application
configure do
  db = get_db
  db.execute 'CREATE TABLE IF NOT EXISTS "Messages"
    (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "username" TEXT,
      "phone" TEXT,
      "email" TEXT,
      "option" TEXT,
      "comment" TEXT
    )'
    db.execute 'CREATE TABLE IF NOT EXISTS "Barbers"
    (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "name" TEXT
    )'
  
end

# Method save form data to database
def save_form_data_to_database
  db = get_db
  db.execute 'INSERT INTO Messages (username, phone, email, option, comment)
  VALUES (?, ?, ?, ?, ?)', [@username, @phone, @email, @option, @comment]
  db.close
end

# Index page with form
get '/' do
  @title = 'Форма заявки для Sinatra (Ruby)'
  erb :index
end

post '/' do
  @username = params[:username]
  @phone = params[:phone]
  @email = params[:email]
  @option = params[:option]
  @comment = params[:comment]

  save_form_data_to_database

  @title = 'Спасибо, ваше сообщение отправлено'
  erb :sent
end

get '/showusers' do 
  db = get_db
  
  @results = db.execute 'select * from Messages order by id desc'

  erb :showusers
end

