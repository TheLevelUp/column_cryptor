require 'rubygems'
require 'active_record'
require 'active_record/version'
require 'test/unit'

require 'shoulda'

ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

$LOAD_PATH << File.join(ROOT, 'lib')
$LOAD_PATH << File.join(ROOT, 'lib', 'column_cryptor')

require File.join(ROOT, 'lib', 'column_cryptor.rb')
require File.join(ROOT, 'test', 'shoulda_macros', 'encrypts.rb')

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

def create_table(name)
  ActiveRecord::Base.connection.create_table name, { force: true }
end
