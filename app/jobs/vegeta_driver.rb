require 'docker'

class VegetaDriver

  HOST_ENV_VAR = 'TEST_HOST_PORT'
  DEFAULT_IMAGE_NAME = 'vegeta'
  VEGETA = "vegeta"

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

  def run_test(endpoint, concurrency, duration)
    puts "VEGETA: #{endpoint} #{concurrency} #{duration}"
=begin
    container = Docker::Container.create('Image' => @image_name, 'Cmd' =>
      ["/opt/benchmark.sh container /", "container #{endpoint} #{concurrency} #{duration}s"])
    container.start
    result = ''
    container.attach(:stdout => true, :stderr => true, :logs => true) do |stream, chunk|
      result << chunk
    end
    result
=end
    puts "#{docker_run_cmd} #{vegeta_args(endpoint, concurrency, duration)}"
    result = `#{docker_run_cmd} #{vegeta_args(endpoint, concurrency, duration)}`
    JSON.parse(result)
  end

  private

  def docker_run_cmd
    #TODO: docker API
    #TODO: support non link full host
    "docker run -i -a stdout -link #{@link_container_name}:test_host #{@image_name}"
  end

  def vegeta_args(endpoint, concurrency, duration)
    "/opt/benchmark.sh container #{endpoint} #{concurrency} #{duration}s"
  end
end