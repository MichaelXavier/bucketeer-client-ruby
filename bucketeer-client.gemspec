Gem::Specification.new do |s|
  s.name        = 'bucketeer-client'
  s.version     = '0.0.1'
  s.summary     = 'HTTP Client to the Bucketeer rate limiting service'
  s.description = <<-EOS
  bucketeer-client is an HTTP client built with Faraday. It is intended to be
  used in filters or middleware to determine if an API user may access a
  resource or if they are throttled. Since it is built with Faraday, HTTP
  backends are interchangeable.
  EOS
  s.authors     = ["Michael Xavier"]
  s.email       = 'michael@michaelxavier.net'
  s.files       = %w[ lib/bucketeer-client.rb
                      lib/bucketeer/bucket.rb
                      lib/bucketeer/client.rb
                      Gemfile ]
  s.require_path = 'lib'

  s.add_runtime_dependency 'json',               '~> 1.6'
  s.add_runtime_dependency 'faraday',            '~> 0.8.0.rc2'
  s.add_runtime_dependency 'faraday_middleware', '~> 0.8.6'

  s.add_development_dependency 'rake' ,       '>= 0.9.0'
  s.add_development_dependency 'guard',       '~> 1.0.1'
  s.add_development_dependency 'rspec',       '~> 2.9.0'
  s.add_development_dependency 'guard-rspec', '~> 0.7.0'
  s.add_development_dependency 'webmock',     '~> 1.8.5'
end
