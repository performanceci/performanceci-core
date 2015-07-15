require 'docker'

class VegetaDriver

  HOST_ENV_VAR = 'TEST_HOST_PORT'
  DEFAULT_IMAGE_NAME = 'perfci/vegeta'
  VEGETA = "vegeta"

  attr_accessor :link_container_name, :base_url

  def initialize(paas_config, options = {})
    @image_name = options[:vegeta_image_name] || DEFAULT_IMAGE_NAME
    if paas_config[:link_container_name]
      @link_container_name = paas_config[:link_container_name]
    elsif paas_config[:base_url]
      @base_url = paas_config[:base_url]
    else
      raise "Base URL or container name must be provided"
    end
  end

  def self.new_with_container_link(container_name)
    new(link_container_name: container_name)
  end

  def self.new_with_base_url(base_url)
    new(base_url: base_url)
  end

  def run_test(endpoint, rate, duration)
    command = "docker run --rm #{vegeta_args(@base_url + endpoint, duration, rate)} #{@image_name}"
    puts "RUNNING: #{command}"
    result = `#{command}`
    HashUtil.symbolize_keys(JSON.parse(result))
  end

  private

  def vegeta_args(endpoint, duration, rate)
    "-e TARGET=#{endpoint} -e DURATION=#{duration}s -e RATE=#{rate}"
  end
end
