require 'spec_helper'

describe DockerBuilder do

  def docker_builder(project_path)
    path = File.join(File.dirname(__FILE__), project_path)
    project_config = ProjectConfiguration.new(path)
    project_config.parse_configuration
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

    it 'should succeed' do
      @build_result.should be_true
    end

    it 'should have docker container running' do
      `docker ps | grep "ruby simple"`.chomp.should_not eq('')
    end

    it 'should have execute logs' do
      @builder.run_logs.should_not be_empty
    end

    it 'should expose port 5555' do
      `docker ps | grep "ruby simple" | grep ">5555/tcp"`.chomp.should_not eq('')
    end

    describe 'build log' do
      it 'should have build logs' do
        @builder.build_logs.should_not be_empty
      end

      it 'should say succesfully built' do
        @builder.build_logs.should match(/Successfully built/)
      end
    end


    it 'should have base test url' do
      @builder.base_test_url.should_not be_empty
    end

    it 'should respond to base test url' do
      resp = `docker run base curl #{@builder.base_test_url}`
      resp.should eq('Hello World')
      @builder.run_logs.should_not be_empty
    end
  end

  context "invalid dockerfile" do
    before(:all) do
      @builder = docker_builder('../support/docker_builder/invalid_build')
      @build_result = @builder.build
    end

    it 'should fail' do
      @build_result.should be_false
    end

    describe 'build log' do
      it 'should have build logs' do
        @builder.build_logs.should_not be_empty
      end

      it 'should have error' do
        @builder.build_logs.should match(/Bundler::GemfileNotFound/)
      end
    end
  end

  it 'should fail if endpoints are not accessible (?)'

end