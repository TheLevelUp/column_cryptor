# column_cryptor

`column_cryptor` is a gem that makes it easy to encrypt/decrypt ActiveRecord columns using a private key. If you need to store some sensitive information in your database, then this makes it easy to keep it encrypted.

Note that `column_cryptor` is NOT a good solution for something like credit card information. Do everyone a favor and use a vault-like service. Instead, use `column_cryptor` to encrypt a user's phone number or other one-off bits of information you'd like to keep secret.

## Getting Started

Add to your Gemfile:

    gem 'column_cryptor'

then run `bundle install`.

Next, use the generator to create an initializer with a random private key:

    rails generate column_cryptor:install

This will create a file called `config/initializers/column_cryptor.rb` that looks something like:

    ColumnCryptor.private_key = "ssWII/MrFX8EmHMjG/5+un0mnYF5UeG2k7ajSjaKayU=\n"

Those random characters represent a Base64-encoded private key suitable for encrypting and decrypting data using `column_cryptor`. It's recommended that you move that private key somewhere outside your code, such as to a yaml file or as an environment variable. Just be sure to set `ColumnCryptor.private_key` to your key.

## Encrypting some data

Once installed, you can then encrypt an ActiveRecord column like so:

    class User < ActiveRecord::Base
      encrypts :phone_number
    end

Getters and setters will be created for each column, automatically encrypting/decrypting `phone_number`.

## Generating a new private key

You can create a new private key using the `new_key` method:

    ColumnCryptor.new_key

This will return a Base64-encoded string representing a random private key. Be sure to leave it as-is (with the new-line at the end!) or ColumnCryptor won't know what do with it.

Note that once you've started using a private key, if you ever lose it, all of your encrypted data will be lost with it. You also can't change your private key on the fly: you would need to first decrypt all of your data and then re-encrypt with your new private key.

## Requirements

`column_cryptor` requires Ruby 1.9+, and Rails 3.0 or later. The tests are written with Test::Unit and shoulda.

## License

`column_cryptor` is written by Ryan Twomey and Costa Walcott, and is Copyright 2012 SCVNGR, Inc. It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
