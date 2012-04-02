module Bucketeer
  class Bucket
    attr_reader :consumer, :feature, :restore_rate, :capacity

    def initialize(consumer, feature, restore_rate, capacity)
      @consumer      = consumer
      @feature       = feature
      @restore_rate  = restore_rate
      @capacity      = capacity
    end

    def ==(other)
      consumer == other.consumer && feature == other.feature
    end
  end
end
