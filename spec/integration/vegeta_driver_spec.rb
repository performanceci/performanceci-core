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

    #ASSUMES: Image name 'vegeta' on docker build (TODO: Add rake task to prep docker images)
    it 'should run benchmark against linked container' do
      vegeta = VegetaDriver.new(:link_container_name => @builder.container_name)
      result = vegeta.run_test('/', 1, 2)
      result.should have_key(:latencies)
      puts result.to_json
      result[:success].should eq(1)
    end
  end

  context 'public endpoint' do
    it 'should run benchmark against public endpoint' do
      vegeta = VegetaDriver.new(:base_url => 'http://www.yahoo.com')
      result = vegeta.run_test('/', 1, 2)
      result.should have_key(:latencies)
      puts result.to_json
      result[:success].should eq(1)
    end
  end
end