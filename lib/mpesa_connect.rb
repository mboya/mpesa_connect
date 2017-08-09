require "mpesa_connect/version"
require 'base64'
require 'redis'
require 'httparty'
require 'openssl'
require 'access_token'
# require 'security_credentials'

module MpesaConnect
  class Client
    BASE_URL = "https://sandbox.safaricom.co.ke"
    BALANCE_URL = "https://sandbox.safaricom.co.ke/mpesa/accountbalance/v1/query"

    def initialize key, secret, security_credentials
      @key = key
      @secret = secret
      @access_token = nil
      @sec_cred = security_credentials
    end

    def set_urls timeout=nil, transaction=nil, confirm=nil, validate=nil 
      @timeout = timeout
      @transaction = transaction
      @confirm = confirm
      @validate = validate
    end

    def account_balance initiator, party_a
      url = "#{BASE_URL}/mpesa/accountbalance/v1/query"
      headers = {
        "Authorization" => "Bearer #{get_token}",
        "Content-Type" => "application/json"
      }
      body = {
        Initiator: "#{initiator}",
        SecurityCredential: "#{@sec_cred}",
        CommandID: "AccountBalance",
        PartyA: "#{party_a}",
        IdentifierType: "4",
        Remarks: "Account Balance",
        QueueTimeOutURL: "#{@timeout}",
        ResultURL: "#{@transaction}"
      }.to_json
      response = HTTParty.post(url, headers: headers, body: body)
      JSON.parse(response.body)
    end

    def transaction_status initiator, party_a, transaction_id
      url = "#{BASE_URL}/mpesa/transactionstatus/v1/query"
      headers = {
        "Authorization" => "Bearer #{get_token}",
        "Content-Type" => "application/json"
      }
      body = {
        Initiator: "#{initiator}",
        SecurityCredential: "#{@sec_cred}",
        CommandID: "TransactionStatusQuery",
        TransactionID: "#{transaction_id}",
        PartyA: "#{party_a}",
        IdentifierType: "1",
        Remarks: "Transaction Status",
        QueueTimeOutURL: "#{@timeout}",
        ResultURL: "#{@transaction}"
      }.to_json

      response = HTTParty.post(url, headers: headers, body: body)
      JSON.parse(response.body)
    end

    def c2b_register_url shortcode, response_type
      url = "#{BASE_URL}/mpesa/c2b/v1/registerurl"
      headers = {
        "Authorization" => "Bearer #{get_token}",
        "Content-Type" => "application/json"
      }
      body = {
        ShortCode: "#{shortcode}",
        ResponseType: "#{response_type}",
        ConfirmationURL: "#{@confirm}",
        ValidationURL: "#{@validate}"
      }.to_json

      response = HTTParty.post(url, headers: headers, body: body)
      JSON.parse(response.body)
    end

    def c2b_transaction shortcode, amount, msisdn, bill_reference=nil
      url = "#{BASE_URL}/mpesa/c2b/v1/simulate"
      headers = {
        "Authorization" => "Bearer #{get_token}",
        "Content-Type" => "application/json"
      }
      body = {
        ShortCode: "#{shortcode}",
        CommandID: "CustomerPayBillOnline",
        Amount: "#{amount}",
        Msisdn: "#{msisdn}",
        BillRefNumber: "#{bill_reference}"
      }.to_json

      response = HTTParty.post(url, headers: headers, body: body)
      JSON.parse(response.body)
    end

    # def security_password security_credentials
    #   @sec_cred = security_credentials
    #   encrypted_security_password
    # end

    private
      def get_token
        AccessToken.new(@key, @secret).access_token
      end

      # def encrypted_security_password
      #   password = SecurityCredentials.new(@sec_cred).encrypt_security_cred
      # end
  
  end
end
