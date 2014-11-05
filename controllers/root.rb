#!/usr/bin/env ruby

def call_print(fn)
  `lp -d HP #{fn}`
end

get '/' do
  halt erb :index unless session[:id]
  erb :index
end

post '/' do
  halt erb :index, locals: { msg: "You have not logged in..."} unless session[:id]
  t = Team.find session[:id]
  halt erb :index, locals: { msg: "You have not access..."} unless t
  cur = "/tmp/#{t.id}_#{Time.now.to_i}.printer"
  open(cur, 'w') do |f|
    f.puts 'Team info: ' + t.username + ' (' + t.teamname + ')'
    f.puts ''
    f.puts params["text"]
  end
  Record.create(
    :team_id => session[:id],
    :text => params["text"],
  )
  # Print it~
  call_print(cur)
  erb :index, locals: { msg: "Submitted successfully!" }
end

post '/login' do
  # login module
  redirect to '/' if session[:id]
  username = params["username"]
  password = params["password"]
  t = Team.find_by_username username
  halt erb :index, locals: { msg: "Something went wrong..." } unless t && t.password == Digest::MD5.hexdigest(password)
  session[:id] = t.id
  redirect to '/'
end

get '/logout' do
  session[:id] = nil
  redirect to '/'
end

get '/view_source' do
  halt erb :index, locals: { msg: "You have not logged in..."} unless session[:id]
  source_id = params["id"]
  t = Record.find source_id
  p = Team.find session[:id]
  halt erb :index, locals: { msg: "You cannot view this code..." } unless t && (t.team_id == session[:id] || p.auth == 100)
  erb :view_source, locals: { code: t.text }
end

get '/relogin' do
  halt erb :index, locals: { msg: "You have not logged in..."} unless session[:id]
  t = Team.find session[:id]
  halt erb :index, locals: { msg: "You cannot do this operation..." } unless t && t.auth == 100
  source_id = params["id"]
  p = Record.find source_id
  cur = "/tmp/#{t.id}_#{Time.now.to_i}.printer"
  open(cur, 'w') do |f|
    f.puts 'Team info: ' + t.username + ' (' + t.teamname + ')'
    f.puts ''
    f.puts params["text"]
  end
  call_print(cur)
  erb :index, locals: { msg: "Reprint successfully!" }
end
