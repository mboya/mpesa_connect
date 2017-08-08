require "mpesa_connect/version"
require 'base64'
require 'redis'
require 'httparty'
require 'openssl'
require 'access_token'
# require 'security_credentials'

module MpesaConnect
  class Client
    BALANCE_URL = "https://sandbox.safaricom.co.ke/mpesa/accountbalance/v1/query"

    def initialize key, secret
      @key = key
      @secret = secret
      @access_token = nil
    end

    def account_balance
      
    end

    def security_password security_credentials
      @sec_cred = security_credentials
      encrypted_security_password
    end

    private
      def get_token
        AccessToken.new(@key, @secret).access_token
      end

      def encrypted_security_password
        password = SecurityCredentials.new(@sec_cred).encrypt_security_cred
      end
  
  end
end
