bucketeer-client
----------------
[![Build Status](https://secure.travis-ci.org/MichaelXavier/bucketeer-client-ruby.png)](http://travis-ci.org/MichaelXavier/bucketeer-client-ruby)

bucketeer-client is a Ruby client for the HTTP rate limiting service,
[Bucketeer](github.com/michaelxavier/Bucketeer). 

Status
======
Not yet on rubygems.

Usage
=====

```ruby
require 'bucketeer/client'

client = Bucketeer::Client.new("http://localhost:3000")

client.buckets
#=> [#<Bucketeer::Bucket: @consumer="michael", @feature="fun_stuff", @restore_rate=10000, @capacity=10>]

client.remaining('michael', 'fun_stuff')
#=> 1

client.tick('michael', 'fun_stuff')
#=> 0

client.tick('michael', 'fun_stuff')
# nil means user has exceeded capacity. Kick 'em to the curb
#=> nil

client.tick('bogus', 'whatever')
# raises Bucketeer::Client::BucketNotFound

consumer = 'another_guy'
feature = 'do_things'
restore_rate = 2000 # 2 seconds, 2000 milliseconds
capacity = 10

new_bucket = Bucketeer::Bucket(consumer, feature, restore_rate, capacity)
client.write_bucket(new_bucket)

client.delete_bucket(consumer, feature)
client.delete_feature(consumer)

client.remaining('michael', 'fun_stuff')
#=> 0

client.refill('michael', 'fun_stuff')
# capacity
#=> 10

client.drain('michael', 'fun_stuff')
# reduce remaining to zero

```
Configuration
=============
The second argument to the initializer is mostly a pass through to Faraday's
options. Additionally, you can specify an `:adapter` option if you want to use
something other than the default backend for Faraday:

```ruby
client = Bucketeer::Client.new("http://localhost:3000",
                               :adapter      => SomeAdapter,
                               :timeout      => 20,
                               :open_timeout => 20)
```
