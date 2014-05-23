require 'spec_helper'

describe VegetaDriver do

  def docker_builder(project_path)
    path = File.join(File.dirname(__FILE__), project_path)
    project_config = ProjectConfiguration.from_build_dir(path)
    DockerBuilder.new(path, project_config)
  end

  context 'working build' do
    before(:all) do
      @builder = docker_builder('../support/docker_builder/valid_run')
      @build_result = @builder.build
    end

    after(:all) do
      #cleanup takes too long, don't worry about it here
      Docker::Image.any_instance.stub(:remove).and_return(true)

      @builder.cleanup
      `docker ps | grep "ruby simple"`.chomp.should eq('')
    end

    it 'should run benchmark' do
      puts "CONTAINER NAME: #{@builder.container_name}"
      vegeta = VegetaDriver.new(:link_container_name => @builder.container_name)
      vegeta.run_test('/', 1, 2).should have_key('latencies')
    end
  end
end