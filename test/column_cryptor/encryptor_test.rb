require './test/test_helper'
require 'base64'

class EncryptorTest < ActiveSupport::TestCase
  context '#encrypt' do
    setup do
      ColumnCryptor.private_key = "dKY56fUpxMF2gmOxDzWoEm1z7bUJwe1jj9a2962T0GA=\n"
    end

    context 'with no data' do
      setup do
        @encryptor = ColumnCryptor::Encryptor.new(nil)
      end

      should 'return nil' do
        assert_nil @encryptor.encrypt
      end
    end

    context 'with plaintext data' do
      setup do
        cipher = OpenSSL::Cipher::AES.new(256, :CBC)
        cipher.stubs random_iv: Base64.decode64('xxl4Ny2fGdOKYaEXTDqdOQ==\n')
        OpenSSL::Cipher::AES.stubs new: cipher

        @encryptor = ColumnCryptor::Encryptor.new('abc123')
        @expected = "xxl4Ny2fGdOKYaEXTDqdOWoNRNd4hT1xe9GlPQ7qWxE=\n"
      end

      should 'encrypt data' do
        assert_equal @expected, @encryptor.encrypt
      end
    end
  end
end
