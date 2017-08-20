require 'base64'
require 'redis'

module MpesaConnect
  class AccessToken
    def initialize key, secret
      @key = key
      @secret = secret
      @redis = Redis.new

      load_from_redis
    end

    def is_valid?
      has_token? && !token_expired?
    end

    def token_expired?
      expire_time = @timestamp.to_i + @expires_in.to_i
      return expire_time < Time.now.to_i + 58
    end

    def has_token?
      return !@token.nil?
    end

    def refresh
      get_new_access_token
      load_from_redis
    end

    def load_from_redis
      data = @redis.get(@key)
      if (data.nil? || data.empty?)
        @token = nil
        @timestamp = nil
        @expires_in = nil
      else
        parsed = JSON.parse(data)
        @token = parsed['access_token']
        @timestamp = parsed['time_stamp']
        @expires_in = parsed['expires_in']
      end
    end

    def access_token
      if is_valid?
        return @token
      else
        refresh
        return @token
      end
    end

    def get_new_access_token
      encode = encode_credentials @key, @secret
      headers = {
        "Authorization" => "Basic #{encode}"
      }
      url = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials"
      response = HTTParty.get(url, headers: headers)

      hash = JSON.parse(response.body).merge(Hash['time_stamp',Time.now.to_i])
      @redis.set @key, hash.to_json
    end

    private
      def encode_credentials key, secret
        credentials = "#{key}:#{secret}"
        encoded_credentials = Base64.encode64(credentials).split("\n").join
      end
  end
end
