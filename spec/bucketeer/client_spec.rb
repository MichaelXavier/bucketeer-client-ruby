require 'bucketeer/bucket'
require 'bucketeer/client'
require 'webmock/rspec'

describe Bucketeer::Client do
  let(:response_body) { ""  }
  let(:status)        { 200 }
  subject { Bucketeer::Client.new('http://example.com') }

  before(:each) do
    stub_request(:any, /^http:\/\/example.com/).
      to_return(:body => response_body, :status => status)
  end

  describe "#buckets" do
    let(:response_body) { %([{"restore_rate":90,"capacity":10,"feature":"barrel_roll","consumer":"summer"}]) }

    it "sends the get request" do
      subject.buckets
      a_request(:get, 'http://example.com/').should have_been_made
    end

    it "returns the results parsed into Buckets" do
      subject.buckets.should == [
        Bucketeer::Bucket.new('summer', 'barrel_roll', 10, 90)
      ]
    end
  end

  describe "#write_bucket" do
    let(:bucket) { Bucketeer::Bucket.new('summer', 'barrel_roll', 10, 90)}
    it "sends the post request" do
      subject.write_bucket(bucket)
      a_request(:post, 'http://example.com/consumers/summer/buckets/barrel_roll').
        with(:data => {:restore_rate => 10, :capacity => 90}).
        should have_been_made
    end

    it "returns the client" do
      subject.write_bucket(bucket).should == subject
    end
  end

  describe "#delete_bucket" do
    it "sends the delete request" do
      subject.delete_bucket('summer', 'barrel_roll')
      a_request(:delete, 'http://example.com/consumers/summer/buckets/barrel_roll').
        should have_been_made
    end

    it "returns the client" do
      subject.delete_bucket('summer', 'barrel_roll').should == subject
    end

    context "bucket not found" do
      let(:status) { 404 }

      it "does not raise" do
        expect { subject.delete_bucket('summer', 'barrel_roll') }.
          not_to raise_error
      end

      it "returns the client" do
        subject.delete_bucket('summer', 'barrel_roll').should == subject
      end
    end
  end

  describe "#delete_consumer" do
    it "sends the delete request" do
      subject.delete_consumer('summer')
      a_request(:delete, 'http://example.com/consumers/summer').
        should have_been_made
    end

    it "returns the client" do
      subject.delete_consumer('summer').should == subject
    end

    context "bucket not found" do
      let(:status) { 404 }

      it "does not raise" do
        expect { subject.delete_consumer('summer') }.
          not_to raise_error
      end

      it "returns the client" do
        subject.delete_consumer('summer').should == subject
      end
    end
  end
end
