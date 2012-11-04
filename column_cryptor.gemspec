$:.push File.expand_path('../lib', __FILE__)
require 'column_cryptor/version'

Gem::Specification.new do |s|
  s.name        = 'column_cryptor'
  s.version     = ColumnCryptor::VERSION
  s.authors     = ['Ryan Twomey', 'Costa Walcott']
  s.email       = ['ryant@thelevelup.com', 'costa@thelevelup.com']
  s.summary     = 'Easily encrypt/decrypt ActiveRecord columns'
  s.description = 'Encrypt data in your database and unencrypt it on the fly.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'activerecord', '>= 3.0.0'
  s.add_dependency 'activesupport', '>= 3.0.0'

  s.required_ruby_version = Gem::Requirement.new('>= 1.9.2')
  s.require_paths = ['lib']

  s.add_development_dependency('bourne')
  s.add_development_dependency('bundler')
  s.add_development_dependency('rake')
  s.add_development_dependency('shoulda')
end
