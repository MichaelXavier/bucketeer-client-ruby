require 'bucketeer/bucket'

describe Bucketeer::Bucket do
  subject { Bucketeer::Bucket.new('summer', 'barrel_roll', 9, 10) }

  its(:consumer)     { should == 'summer'      }
  its(:feature)      { should == 'barrel_roll' }
  its(:restore_rate) { should == 9             }
  its(:capacity)     { should == 10            }

  describe "#==" do
    it "compares consumer and feature" do
      subject.should == Bucketeer::Bucket.new('summer', 'barrel_roll', 1, 2)
      subject.should_not == Bucketeer::Bucket.new('scout', 'bonk', 3, 4)
    end
  end

  describe "#to_s" do
    its(:to_s) { should == %(#<Bucketeer::Bucket: @consumer="summer", @feature="barrel_roll", @restore_rate=9, @capacity=10>) }
  end
end

