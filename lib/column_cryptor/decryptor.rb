module ColumnCryptor
  # Given some ciphertext, attempts to decrypt it. Requires that ColumnCryptor.private_key be
  # previously set to the same private key used to create the ciphertext.

  class Decryptor
    # Returns a new ColumnCryptor::Decryptor object initialized with the given ciphertext.
    def initialize(encrypted_data)
      @encrypted_data = encrypted_data
    end

    # Returns decrypted version of the Base64-encoded ciphertext.
    def decrypt
      unless @encrypted_data.blank?
        plaintext_data
      end
    end

    private

    def decipher
      @decipher ||= OpenSSL::Cipher::AES.new(256, :CBC).tap do |decipher|
        decipher.decrypt
        decipher.key = private_key
      end
    end

    def deciphertext
      decipher.update(decoded_data) + decipher.final
    end

    def decoded_data
      @decoded_data ||= Base64.decode64(@encrypted_data)
    end

    def initialization_vector
      decoded_data.slice! 0, decipher.block_size
    end

    def plaintext_data
      decipher.iv = initialization_vector
      deciphertext
    end

    def private_key
      Base64.decode64 ColumnCryptor.private_key
    end
  end
end
