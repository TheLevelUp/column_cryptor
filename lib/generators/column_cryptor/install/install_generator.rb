require 'rails/generators/active_record'

module ColumnCryptor
  # Creates an initializer with a random private key
  class InstallGenerator < Rails::Generators::Base
    desc 'Add the column_cryptor initializer'

    #:nodoc:
    def self.source_root
      @source_root ||= File.expand_path('../templates', __FILE__)
    end

    #:nodoc:
    def install_initializer
      template 'initializer.rb.erb', 'config/initializers/column_cryptor.rb'
    end
  end
end
