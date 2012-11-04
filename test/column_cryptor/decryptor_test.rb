require './test/test_helper'
require 'base64'

class DecryptorTest < ActiveSupport::TestCase
  context '#decrypt' do
    setup do
      ColumnCryptor.private_key = "dKY56fUpxMF2gmOxDzWoEm1z7bUJwe1jj9a2962T0GA=\n"
    end

    context 'with no data' do
      setup do
        @decryptor = ColumnCryptor::Decryptor.new(nil)
      end

      should 'return nil' do
        assert_nil @decryptor.decrypt
      end
    end

    context 'with encrypted data' do
      setup do
        decryptor = ColumnCryptor::Decryptor.new("xxl4Ny2fGdOKYaEXTDqdOWoNRNd4hT1xe9GlPQ7qWxE=\n")
        @result = decryptor.decrypt
      end

      should 'decrypt to plaintext' do
        assert_equal 'abc123', @result
      end
    end
  end
end
