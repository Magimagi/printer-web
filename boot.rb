SINATRA_ENV = ENV['SINATRA_ENV'] ||= ENV['RACK_ENV'] ||= 'development' unless defined? SINATRA_ENV
SINATRA_ROOT = File.expand_path('..', __FILE__) unless defined? SINATRA_ROOT
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)

require 'rubygems' unless defined? Gem
require 'bundler/setup' if File.exists? ENV['BUNDLE_GEMFILE']
Bundler.require(:default, SINATRA_ENV)

require File.expand_path('../application.rb', __FILE__)
