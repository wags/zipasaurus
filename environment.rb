require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require :default
require 'pp'

class ZipasaurusApp < Sinatra::Base

  require File.join(File.expand_path(File.dirname(__FILE__)), 'controller.rb')
  require File.join(File.expand_path(File.dirname(__FILE__)), 'api.rb')

  Dir.glob(['lib', 'models'].map! {|d| File.join File.expand_path(File.dirname(__FILE__)), d, '*.rb'}).each {|f| require f}

  configure :development do
    use Rack::ShowExceptions
  end

  configure :production do
    CouchRest::Model::Base.configure do |conf|
      conf.environment = ZipasaurusApp.environment
      conf.connection_config_file = File.join('.', 'config', 'couchdb.yml')
    end
  end
  
  use Rack::CommonLogger
  use Rack::MethodOverride
  use Rack::JSONP

  set :static, true
  set :root, File.expand_path(File.dirname(__FILE__))
  set :public_folder, File.join(root, 'static')
  set :dump_errors, true
end

puts "Starting in #{ZipasaurusApp.environment} mode..."