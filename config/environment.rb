require 'bundler'
require 'rest-client'
require 'json'
require 'require_all'

Bundler.require
require_all 'app'


DB = ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/hangman.db')
require_all 'lib'
require_all 'app'
ActiveRecord::Base.logger = nil