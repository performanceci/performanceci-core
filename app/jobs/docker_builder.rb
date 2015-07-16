require 'docker'
require 'shell'

class DockerBuilder

  SERVER_HOST = ENV['SERVER_HOST'] || '127.0.0.1'
  DEFAULT_READ_TIMEOUT = 600

  attr_reader :src_dir, :image, :errors, :container,
              :host_port, :container_port, :build_logs

  def initialize(src_dir, project_configuration, options = {})
    @src_dir = src_dir
    @errors = []
    @container = nil
    @image = nil
    @container_port = project_configuration.port
    @host_port  = options[:host_port] || rand(8000..65535)
    Docker.options[:read_timeout] = ENV['DOCKER_READ_TIMEOUT'] || DEFAULT_READ_TIMEOUT
  end

  def cleanup
    container.stop(force: true) if container
    container.delete(force: true) if container
    image.remove(force: true) if image
  rescue Exception => e
    puts "Error: #{e.to_s} #{e.backtrace}"
  end

  def build
    if build_image
      run_container
    else
      false
    end
  end

  def run_logs
    if container
      @run_logs ||= Worker.system_capture("docker logs #{container.id}".split(' '))
    end
  end

  def container_name
    @container.info["Name"].gsub('/', '')
  end

  def build_image
    begin
      puts "DockerBuilder: Building Target Image from [#{src_dir}]"
      @image = Docker::Image.build_from_dir(src_dir)
      #TODO: Capture errors
      true
    rescue Exception => e
      puts "Error: #{e.to_s}\n#{e.backtrace}"
      errors << e.to_s + "\n" + e.backtrace.to_s
      false
    end
  end

  def run_container
    begin
      puts "DockerBuilder: Creating Target Container from [#{image.id}]"
      @container = Docker::Container.create(
        "PortBindings" => {
          "#{container_port}/tcp" => [ "HostPort" => "#{host_port}" ]
        },
        "Image" => "#{image.id}"
      )
      puts "DockerBuilder: Starting Target Container [#{container.id}]"
      container.start
      #TODO: Capture errors
      true
    rescue Exception => e
      puts "Error: #{e.to_s}\n#{e.backtrace}"
      errors << e.to_s + "\n" + e.backtrace.to_s
      false
    end
  end

  #TODO: return hostname for multi machine builds
  def base_test_url
    "http://#{SERVER_HOST}:#{host_port}"
  end
end
