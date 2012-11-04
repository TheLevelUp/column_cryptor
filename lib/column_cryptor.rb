# This gem makes it easy to encrypt and decrypt sensitive application data using ActiveRecord. It
# adds a getter and setter for each encryptable column, transparently encrypting before writing to
# the database, and decrypting when reading.
#
# Author::    Ryan Twomey  (mailto:ryant@scvngr.com)
# Copyright:: Copyright (c) 2012 SCVNGR, Inc.
# License::   MIT

# Sets up ColumnCryptor and includes it on all ActiveRecord::Base objects.

require 'active_support/core_ext/string'
require 'base64'
require 'openssl'

require 'column_cryptor/decryptor'
require 'column_cryptor/encryptor'
require 'column_cryptor/version'

module ColumnCryptor
  @@private_key = nil

  #:nodoc:
  def self.included(base)
    base.extend ClassMethods
  end

  # Returns a randomly generated key, Base64 encoded, suitable for sending to
  # ColumnCryptor.private_key=
  def self.new_key
    Base64.encode64 cipher.random_key
  end

  # Sets the globally-used private key for all encryption/decryption operations.
  def self.private_key=(private_key)
    @@private_key = private_key
  end

  # Returns the currently set private_key, or nil.
  def self.private_key
    @@private_key
  end

  module ClassMethods
    # Define which columns to mark as being encrypted. For example, if your ActiveRecord model has
    # two columns you'd like to encrypt named "address" and "phone_number", you would call this as:
    #
    # encrypts :address, :phone_number
    #
    # This will define two methods for each attribute: a getter (i.e. "address") and a setter
    # (i.e. "address="). The getter will automatically attempt to decrypt the data, while the
    # setter will attempt to encrypt the data. When ActiveRecord writes your record to the database,
    # the values of these columns will be the ciphertext.
    #
    # Note that you must set ColumnCryptor.private_key prior to using these setters/getters.
    def encrypts(*args)
      if args.respond_to?(:each)
        args.each do |attribute|
          define_encryption_methods attribute
        end
      else
        define_encryption_methods args
      end
    end

    private

    def define_encryption_methods(attribute)
      define_method attribute do
        encrypted_data = send("#{attribute}_encrypted")
        ColumnCryptor::Decryptor.new(encrypted_data).decrypt
      end

      define_method "#{attribute}=" do |new_value|
        encrypted_data = ColumnCryptor::Encryptor.new(new_value).encrypt
        send "#{attribute}_encrypted=", encrypted_data
      end
    end
  end

  private

  def self.cipher
    OpenSSL::Cipher::AES.new(256, :CBC)
  end
end

require 'column_cryptor/core_ext'
