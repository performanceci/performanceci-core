require 'yaml'
class ProjectConfiguration
  DEFAULT_MAX_RESP = 0.5
  DEFAULT_TARGET_RESP = 0.3
  DEFAULT_CONCURRENCY = 10
  DEFAULT_DURATION = 5
  DEFAULT_METHOD = 'GET'

  attr_reader :errors, :configuration

  def initialize(config_hash)
    @errors = []
    if config_hash
      parse_configuration(config_hash)
    end
  end

  def self.from_build_dir(build_dir)
    # Read endpoints from perfci.yaml
    if File.exists?("#{build_dir}/.perfci.yaml")
      conf = File.read("#{build_dir}/.perfci.yaml")
      config_hash = YAML.load(conf)
      ProjectConfiguration.new(config_hash)
    else
      config = ProjectConfiguration.new(nil)
      config.errors << "Project is missing .perfci.yaml file"
      config
    end
  rescue Exception => e
    puts e
    config = ProjectConfiguration.new(nil)
    config.errors << e.to_s
    config
  end

  def endpoints
    configuration[:endpoints]
  end

  def port
    configuration[:port]
  end

  def valid?
    errors.empty?
  end

  private

  def parse_configuration(config_hash)
    user_endpoints = (config_hash['endpoints'] || [])
    endpoints = user_endpoints.map do |endpoint|
      {
        :uri => endpoint['uri'],
        :headers => endpoint['headers'] || {},
        :body => endpoint['body'],
        :method => endpoint['method'] || DEFAULT_METHOD,
        :max_response_time    => endpoint['max_response_time']    || DEFAULT_MAX_RESP,
        :target_response_time => endpoint['target_response_time'] || DEFAULT_TARGET_RESP,
        :concurrency => endpoint['concurrency'] || DEFAULT_CONCURRENCY,
        :duration => endpoint['duration'] || DEFAULT_DURATION
      }
    end
    port = config_hash['port']
    puts config_hash.to_json
    @configuration = {
      endpoints: endpoints,
      port: port
    }
  rescue Exception => e
    puts e
    errors << e.to_s
  end
end
