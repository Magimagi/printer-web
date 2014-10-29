#!/usr/bin/env ruby
# File: Create the database for site.
# Author: Magica
# Date: 2014.10.03
##########################################
require 'active_record'
ActiveRecord::Base.establish_connection adapter: 'sqlite3',
                                        database: File.expand_path('../db.sqlite', __FILE__)
ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :realname
    t.string :nickname
    t.string :grade
    t.string :major
    t.string :age
    t.string :phone
    t.string :about
    t.string :email
  end
end
