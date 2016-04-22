#!/usr/bin/env ruby

def call_print(fn)

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
  if t.auth == 100 || t.login_ip == nil then
    t.login_ip = request.ip
    t.save
  else
    if t.login_ip != request.ip then
      Record.create(
        :team_id => 1,
        :text => "Cheating found! For team #{username} (#{request.ip}).",
      )
      halt erb :index, locals: { msg: "DO NOT DO BAD THINGS..." }
    end
  end
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
  halt erb :index, locals: { msg: "View source disable in the contest..." } unless t && (p.auth == 100)
  erb :view_source, locals: { code: t.text }
end

get '/reprint' do
  halt erb :index, locals: { msg: "You have not logged in..."} unless session[:id]
  t = Team.find session[:id]
  halt erb :index, locals: { msg: "You cannot do this operation..." } unless t && t.auth == 100
  source_id = params["id"]
  p = Record.find source_id
  #cur = "/tmp/#{t.id}_#{Time.now.to_i}.printer"
  #open(cur, 'w') do |f|
  #  f.puts 'Team info: ' + t.username + ' (' + t.teamname + ')'
  #  f.puts ''
  #  f.puts params["text"]
  #end
  #call_print(cur)
  p.finished_at = nil
  p.save
  erb :index, locals: { msg: "Reprint successfully!" }
end

get '/getqueue' do
  id_first = params["first"]
  id_last = params["last"]
  p = Record.where(finished_at: [nil], team_id: id_first..id_last).first
  p.finished_at = Time.now
  p.save
  t = Team.find p.team_id
  erb "Team info: #{t.username} (#{t.teamname})\n\n#{p.text}"
end