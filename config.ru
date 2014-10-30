#!/usr/bin/env rackup

require File.expand_path('../boot.rb', __FILE__)

PROJECT_NAME = '2014 Printer'

use Rack::Session::Cookie, secret: 'YourSecretHere'
set :protection, session: true
require 'rack/csrf'
use Rack::Csrf

run Sinatra::Application

