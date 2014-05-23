require 'docker'

#TODO: Sanitize inputs
#TODO: Go service (?)
class VegetaDriver

  HOST_ENV_VAR = 'TEST_HOST_PORT'
  DEFAULT_IMAGE_NAME = 'vegeta'
  VEGETA = "vegeta"

  def initialize(options = {})
    @image_name = options[:image_name] || DEFAULT_IMAGE_NAME
    if options[:link_container_name]
      @link_container_name = options[:link_container_name]
    elsif options[:base_url]
      @base_url = options[:base_url]
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
    #cid = `#{docker_run_cmd} #{vegeta_args(endpoint, concurrency, duration)}`
    #puts "CID IS: #{cid}"
    #{}`docker logs #{cid}`

    puts "#{docker_run_cmd} #{vegeta_args(endpoint, concurrency, duration)}"
    result = `#{docker_run_cmd} #{vegeta_args(endpoint, concurrency, duration)}`
    JSON.parse(result)
  end

  private

  #{"latencies"=>{"mean"=>1039843164, "50th"=>1035145694, "95th"=>1035145694, "99th"=>1035145694, "max"=>1044540635}, "bytes_in"=>{"total"=>24, "mean"=>12}, "
  # bytes_out"=>{"total"=>0, "mean"=>0}, "duration"=>999755370, "requests"=>2, "success"=>1, "status_codes"=>{"200"=>2}, "errors"=>[]}

  def docker_run_cmd
    #TODO: docker API
    #TODO: support non link full host
    "docker run -i -a stdout -link #{@link_container_name}:test_host #{@image_name}"
  end

  def vegeta_args(endpoint, concurrency, duration)
    "/opt/benchmark.sh container #{endpoint} #{concurrency} #{duration}s"
  end
end