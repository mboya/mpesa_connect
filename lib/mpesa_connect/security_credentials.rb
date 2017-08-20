require 'pry'
require 'pry-nav'
require 'openssl'

module MpesaConnect
  class SecurityCredentials

    def initialize security_cred
      @security_cred = security_cred
    end

    def encrypt_security_cred
      byte_array = @security_cred.bytes.to_a.to_s
      key_file = "lib/pubkey.pem"
      public_key = File.read(key_file)
      ssl = OpenSSL::PKey::RSA.new(public_key)

      encrypted_string = Base64.encode64(ssl.public_encrypt(byte_array)).split("\n").join
    end

  end
end