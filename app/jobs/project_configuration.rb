require 'yaml'
class ProjectConfiguration
  DEFAULT_MAX_RESP = 0.3
  DEFAULT_TARGET_RESP = 0.1

  attr_reader :errors, :configuration

  def initialize(config_hash)
    @errors = []
    if config_hash
      parse_configuration(config_hash)
    end
  end

  def self.from_build_dir(build_dir)
    # Read endpoints from perfci.yaml
    conf = File.read("#{build_dir}/.perfci.yaml")
    config_hash = YAML.load(conf)
    ProjectConfiguration.new(config_hash)
  rescue Exception => e
    puts e
    config = ProjectConfiguration.new(nil)
    config.errors << e.to_s
  end

  def valid?
    errors.empty?
  end

  private

  def parse_configuration(config_hash)
    endpoints = (config_hash['endpoints'] || [])
    configuration = endpoints.map do |endpoint|
      {
        :uri => endpoint['uri'],
        :headers => endpoint['headers'] || {},
        :max_response_time    => (endpoint['max_response_time']    || DEFAULT_MAX_RESP),
        :target_response_time => (endpoint['target_response_time'] || DEFAULT_TARGET_RESP)
      }
    end
    port = config_hash['port']
    unless port
      errors << "Please specify a single 'port' to export"
      return false
    end
    @configuration = {
      endpoints: endpoints,
      port: port
    }
  rescue Exception => e
    puts e
    errors << e.to_s
  end
end