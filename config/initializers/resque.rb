require 'resque'
require 'resque-status'

config = YAML::load(File.open("#{Rails.root}/config/redis.yml"))[Rails.env]
Resque.redis = Redis.new(:host => config['host'], :port => config['port'], :thread_safe => true)

Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds
