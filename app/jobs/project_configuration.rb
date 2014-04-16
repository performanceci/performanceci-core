class ProjectConfiguration
  DEFAULT_MAX_RESP = 0.3
  DEFAULT_TARGET_RESP = 0.1

  attr_reader :build_dir, :errors, :configuration

  def initialize(build_dir)
    @build_dir = build_dir
    @errors = []
  end

  def parse_configuration
    # Read endpoints from perfci.yaml
    conf = File.read("#{build_dir}/.perfci.yaml")
    yaml_hash = YAML.load(conf)
    endpoints = (yaml_hash['endpoints'] || []).map { |endpoint| endpoint }
    configuration = endpoints.map do |endpoint|
      {
        :uri => endpoint['uri'],
        :headers => endpoint['headers'] || {},
        :max_response_time    => (endpoint['max_response_time']    || DEFAULT_MAX_RESP),
        :target_response_time => (endpoint['target_response_time'] || DEFAULT_TARGET_RESP)
      }
    end
    true
  rescue Exception => e
    puts e
    errors << e.to_s
    false
  end

  def errors
    []
  end
end