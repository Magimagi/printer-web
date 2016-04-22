#!/usr/bin/env ruby
# File: Create the database for site.
# Author: Magica
# Date: 2014.10.03
##########################################
require 'active_record'
ActiveRecord::Base.establish_connection adapter: 'sqlite3',
                                        database: File.expand_path('../db.sqlite', __FILE__)
ActiveRecord::Schema.define do
  create_table :teams, force: true do |t|
    t.string :username
    t.string :password
    t.string :teamname
    t.string :position
    t.string :login_ip
    t.integer :auth
    t.integer :count
  end
  create_table :records, force: true do |t|
    t.integer :team_id
    t.string :text
    t.datetime :created_at
    t.datetime :finished_at
  end
end

# Generate root user
require "../models/team.rb"
require 'digest'
Team.create(username: 'root',
            password: Digest::MD5.hexdigest('zjuicpc'),
            teamname: 'Root',
            position: 'None',
            auth: 100,
            count: 0)
#open('nb2015utf.csv', 'r') do |f|
#	while data = f.gets do
#		data = data.split ','
#		Team.create(username: data[2],
#					password: Digest::MD5.hexdigest(data[4].chomp),
#					teamname: "#{data[0]} - #{data[1]}",
#					count: 0)
#	end
#end
