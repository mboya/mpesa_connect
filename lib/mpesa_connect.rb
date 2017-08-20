require "mpesa_connect/version"
require 'mpesa_connect/access_token'
require 'httparty'

module MpesaConnect
  class Client
    BASE_URL = "https://sandbox.safaricom.co.ke"

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
        PartyA: party_a,
        IdentifierType: "4",
        Remarks: "Account Balance",
        QueueTimeOutURL: "#{@timeout}",
        ResultURL: "#{@transaction}"
      }.to_json
      response = HTTParty.post(url, headers: headers, body: body)
      JSON.parse(response.body)
    end

    def reversal initiator, transaction_id, amount, receiver_party
      url = "#{BASE_URL}/mpesa/reversal/v1/request"
      headers = {
        "Authorization" => "Bearer #{get_token}",
        "Content-Type" => "application/json"
      }
      body = {
        Initiator: "#{initiator}",
        SecurityCredential: "#{@sec_cred}",
        CommandID:"TransactionReversal",
        TransactionID: "#{transaction_id}",
        Amount: "#{amount}",
        ReceiverParty: "#{receiver_party}",
        RecieverIdentifierType:"4",
        ResultURL: "#{@transaction}",
        QueueTimeOutURL: "#{@timeout}",
        Remarks: "reverse transaction #{transaction_id}"
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
        IdentifierType: "3",
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

    def b2c_transaction initiator, amount, party_a, party_b, 
      url = "#{BASE_URL}/mpesa/b2c/v1/paymentrequest"
      headers = {
        "Authorization" => "Bearer #{get_token}",
        "Content-Type" => "application/json"
      }
      body = {
        InitiatorName: "#{initiator}",
        SecurityCredential: "#{@sec_cred}",
        CommandID: "SalaryPayment",
        Amount: "#{amount}",
        PartyA: "#{party_a}",
        PartyB: "#{party_b}",
        Remarks: "Salary Payments",
        QueueTimeOutURL: "#{@timeout}",
        ResultURL: "#{@transaction}"
      }.to_json
      response = HTTParty.post(url, headers: headers, body: body)
      JSON.parse(response.body)
    end

    def security_password security_credentials
      @sec_cred = security_credentials
      encrypted_security_password
    end

    private
      def get_token
        MpesaConnect::AccessToken.new(@key, @secret).access_token
      end

      def encrypted_security_password
        password = SecurityCredentials.new(@sec_cred).encrypt_security_cred
      end
  
  end
end
