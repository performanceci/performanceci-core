require 'docker'

class VegetaDriver

  HOST_ENV_VAR = 'TEST_HOST_PORT'
  DEFAULT_IMAGE_NAME = 'perfci/vegeta:0.1.0'
  VEGETA = "vegeta"

  attr_accessor :link_container_name, :base_url, :container,
                :image

  def initialize(paas_config, options = {})
    @image_name = options[:vegeta_image_name] || DEFAULT_IMAGE_NAME
    if paas_config[:link_container_name]
      @link_container_name = paas_config[:link_container_name]
    elsif paas_config[:base_url]
      @base_url = paas_config[:base_url]
    else
      raise "Base URL or container name must be provided"
    end
    @container = nil
    @image = nil
  end

  def self.new_with_container_link(container_name)
    new(link_container_name: container_name)
  end

  def self.new_with_base_url(base_url)
    new(base_url: base_url)
  end

  def pull_image
    puts "VegetaDriver: Pulling Benchmark Image from [#{@image_name}]"
    @image = Docker::Image.create("fromImage" => "#{@image_name}")
  end

  def create_container(target, duration, rate)
    puts "VegetaDriver: Creating Benchmark Container from [#{image.id}]"
    @container = Docker::Container.create(
      "Env"   => [ "TARGET=#{target}",
                   "DURATION=#{duration}s",
                   "RATE=#{rate}" ],
      "Image" => "#{image.id}"
    )
  end

  def run_test(endpoint, rate, duration)
    pull_image unless image
    create_container(@base_url + endpoint, duration, rate)
    puts "VegetaDriver: Starting Benchmark Container [#{container.id}]"
    container.start
    container.wait
    logs = container.attach(:stream => false, :logs => true, :tty => false)
    cout = logs[0]
    cerr = logs[1]
    cleanup
    HashUtil.symbolize_keys(JSON.parse(cout[0]))
  end

  private

  def cleanup
    container.stop(force: true) if container
    container.delete(force: true) if container
  end

end
