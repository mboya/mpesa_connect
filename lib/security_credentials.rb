require 'pry'
require 'pry-nav'

module MpesaConnect
  class SecurityCredentials

    def initialize security_cred
      @security_cred = security_cred
    end

    def encrypt_security_cred
      binding.pry

      public_key_file = "lib/cert.cer"
      # create byte array of paasword
      byte_array = @security_cred.bytes.to_a
      # encrypt with mpesa public key certificate
      # Use the RSA algorithm, and use PKCS #1.5 padding (not OAEP)
      # and add the result to the encrypted stream
      public_key = File.read(public_key_file)
      # public_key = OpenSSL::PKey::RSA.new(File.read(public_key_file))

      # encode
      encrypted_string = OpenSSL::PKey::RSA.new(Base64.encode64(public_key.public_encrypt(byte_array)))
      # encrypted_string = Base64.encode64(public_key.public_encrypt(byte_array))
    end

  end
end