module Encrypts
  def should_encrypt(attribute)
    encrypted_data = 'encrypted data'
    decrypted_data = 'decrypted data'

    context "##{attribute}" do
      setup do
        subject.send "#{attribute}_encrypted=", encrypted_data
        @decryptor = stub(decrypt: decrypted_data)
      end

      should "return #{attribute}_encrypted after decrypting" do
        DataDecryptor.expects(:new).with(encrypted_data).returns(@decryptor)

        result = subject.send(attribute)
        assert_equal decrypted_data, result
      end
    end

    context "##{attribute}=" do
      setup do
        @encryptor = stub(encrypt: encrypted_data)
      end

      should "set #{attribute}_encrypted" do
        DataEncryptor.expects(:new).with(decrypted_data).returns(@encryptor)

        subject.send "#{attribute}=", decrypted_data
        assert_equal encrypted_data, subject.send("#{attribute}_encrypted")
      end
    end
  end
end

class Test::Unit::TestCase
  extend Encrypts
end
