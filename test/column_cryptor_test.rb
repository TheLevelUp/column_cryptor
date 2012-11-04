require './test/test_helper'

class ColumnCryptorTest < ActiveSupport::TestCase
  context '.included' do
    context 'on the class' do
      setup do
        @test_class = Class.new(ActiveRecord::Base)
      end

      should 'define encrypts method' do
        assert @test_class.respond_to?(:encrypts)
      end
    end

    context 'on the instance' do
      setup do
        test_class = Class.new(ActiveRecord::Base) do
          encrypts :secret_data
        end

        klass = Object.const_set('Dummy', test_class)
        create_table 'dummies'

        @test_object = klass.new
      end

      should 'define getter and setter methods' do
        assert @test_object.respond_to?(:secret_data)
        assert @test_object.respond_to?(:secret_data=)
      end
    end
  end

  context '.new_key' do
    setup do
      key_str = 'abc123'
      cipher = stub(random_key: key_str)
      OpenSSL::Cipher::AES.stubs new: cipher

      @expected = Base64.encode64(key_str)
    end

    should 'return expected key' do
      assert_equal @expected, ColumnCryptor.new_key
    end
  end

  context '.private_key' do
    setup do
      ColumnCryptor.private_key = 'abc123'
    end

    should 'return abc123' do
      assert_equal 'abc123', ColumnCryptor.private_key
    end
  end
end
