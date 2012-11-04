module ColumnCryptor
  # Given some plaintext, attempts to encrypt it. Requires that ColumnCryptor.private_key be set.

  class Encryptor
    # Returns a new ColumnCryptor::Encryptor object initialized with the given plaintext.
    def initialize(plaintext)
      @plaintext = plaintext
    end

    # Returns a Base64-encoded string of the encrypted (ciphertext) version of the plaintext.
    def encrypt
      unless @plaintext.blank?
        Base64.encode64 encrypted_data
      end
    end

    private

    def cipher
      @cipher ||= OpenSSL::Cipher::AES.new(256, :CBC).tap do |cipher|
        cipher.encrypt
        cipher.key = private_key
      end
    end

    def ciphertext
      cipher.update(@plaintext) + cipher.final
    end

    def encrypted_data
      cipher.iv = initialization_vector
      initialization_vector + ciphertext
    end

    def initialization_vector
      @initial_vector ||= cipher.random_iv
    end

    def private_key
      Base64.decode64 ColumnCryptor.private_key
    end
  end
end
