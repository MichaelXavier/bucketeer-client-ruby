require 'forwardable'
require 'faraday'
require 'faraday_middleware'

module Bucketeer
  class Client
    extend Forwardable

    def_delegators :@connection, :get, :post, :delete

    class BucketNotFound < StandardError; end

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
      request(:get, "/consumers/#{consumer}/buckets/#{feature}")['remaining']
    end

    def tick(consumer, feature)
      request(:post, "/consumers/#{consumer}/buckets/#{feature}/tick")['remaining']
    end

    def refill(consumer, feature)
      request(:post, "/consumers/#{consumer}/buckets/#{feature}/refill")['remaining']
    end

    def drain(consumer, feature)
      request(:post, "/consumers/#{consumer}/buckets/#{feature}/drain")
      self
    end

  private

    def request(meth, url, *args)
      resp = send(meth, url, *args)
      raise BucketNotFound, url if resp.status == 404
      resp.body
    end
    
    def new_bucket(hash)
      Bucketeer::Bucket.new(hash.fetch('consumer'),
                            hash.fetch('feature'),
                            hash.fetch('restore_rate'),
                            hash.fetch('capacity'))
    end
  end
end
