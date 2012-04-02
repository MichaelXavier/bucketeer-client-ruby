require 'forwardable'
require 'faraday'
require 'faraday_middleware'

module Bucketeer
  class Client
    extend Forwardable

    def_delegators :@connection, :get, :post, :delete

    def initialize(base_url, adapter = Faraday.default_adapter)
      @connection = Faraday.new(base_url) do |conn|
        conn.response :json
        conn.adapter adapter
      end
    end

    def buckets
      get('/').body.map(&method(:new_bucket))
    end

    def write_bucket(bucket)
      post("/consumers/#{bucket.consumer}/buckets/#{bucket.feature}",
           :restore_rate => bucket.restore_rate, :capacity => bucket.capacity) 
      self
    end

    def delete_bucket(consumer, feature)
      delete("/consumers/#{consumer}/buckets/#{feature}")
      self
    end

    def delete_consumer(consumer)
      delete("/consumers/#{consumer}")
      self
    end

    def remaining(consumer, feature)
      
    end

    def tick(consumer, feature)
      
    end

    def refill(consumer, feature)
      
    end

    def drain(consumer, feature)
      
    end

  private
    
    def new_bucket(hash)
      Bucketeer::Bucket.new(hash.fetch('consumer'),
                            hash.fetch('feature'),
                            hash.fetch('restore_rate'),
                            hash.fetch('capacity'))
    end
  end
end
