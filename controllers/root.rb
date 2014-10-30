#!/usr/bin/env ruby

get '/' do
  if not session[:id]
    erb :index
  else
    t = Teams.find_by_id(session[:id])
    if t.auth == 100
      erb :admin
    else
      erb :index
    end
  end
end

post '/' do
  halt erb :index, locals: { msg: "You have not login..."} unless session[:id]
  t = Teams.find_by_id(session[:id])
  cur = "/tmp/#{Time.now.to_i}.printer"
  open(cur, 'w') do |f|
    f.puts 'Team info: ' + t.username + ' (' + t.teamname + ')'
    f.puts ''
    f.puts params["text"]
  end
  p = Records.create(
    :teamid => session[:id],
    :text => params["text"],
    :create_time => Time.now
  )
  # Print it~
  `lp -d HP #{cur}`
  erb :index, locals: { msg: "Submit OK!" }
end

post '/login' do
  # login module
  if session[:id]
    redirect to '/'
  end
  username = params["username"]
  password = params["password"]
  t = Teams.find_by_username(username)
  halt erb :index, locals: { msg: "Something went wrong..." } unless (t) && (t.password == Digest::MD5.hexdigest(password))
  session[:id] = t.id
  puts t.id
  redirect to '/'
end

get '/logout' do
  session[:id] = nil
  redirect to '/'
end

get '/view_source' do
  halt erb :index, locals: { msg: "You have not login..."} unless session[:id]
  source_id = params["id"]
  t = Records.find_by_id(source_id)
  halt erb :index, locals: { msg: "You cannot view this code..." } unless (t) && (t.teamid == session[:id])

  erb :view_source, locals: { code: t.text }
end