#!/usr/bin/env ruby
# File: Main file for site
# Author: Magica
# Date: 2014.10.03
##########################################
get '/' do
  erb :index
end

post '/' do
  cur = "/tmp/#{Time.now.to_i}.printer"
  open(cur, 'w') do |f|
    f.puts params["text"]
  end
  `lp -d HP #{cur}`
  erb :index, locals: { msg: "ok" }
end
