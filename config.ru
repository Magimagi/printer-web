#!/usr/bin/env rackup

require File.expand_path('../boot.rb', __FILE__)

PROJECT_NAME = '第十六届浙江大学程序设计竞赛 打印系统'

use Rack::Session::Cookie, secret: 'YourSecretHere'
set :protection, session: true
require 'rack/csrf'
use Rack::Csrf

run Sinatra::Application

