require 'spec_helper'

describe DockerBuilder do

  def docker_builder(project_path)
    path = File.join(File.dirname(__FILE__), project_path)
    project_config = ProjectConfiguration.from_build_dir(path)
    DockerBuilder.new(path, project_config)
  end

  context 'working build' do
    before(:all) do
      @builder = docker_builder('../support/docker_builder/valid_run')
      @result = @builder.build
    end

    after(:all) do
      #cleanup takes too long, don't worry about it here
      Docker::Image.any_instance.stub(:remove).and_return(true)

      @builder.cleanup
      `docker ps | grep "ruby simple"`.chomp.should eq('')
    end

    it 'should succeed' do
      @result.should be_true
    end

    it 'should have docker container running' do
      `docker ps | grep "ruby simple"`.chomp.should_not eq('')
    end

    it 'should have execute logs' do
      sleep(1)
      @builder.run_logs.should_not be_empty
    end

    it 'should have name' do
      @builder.container_name.should_not be_empty
    end

    it 'should expose port 9080' do
      `docker ps | grep "ruby simple" | grep ">9080/tcp"`.chomp.should_not eq('')
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
  end

  context "invalid dockerfile" do
    before(:all) do
      @builder = docker_builder('../support/docker_builder/missing_dockerfile')
      @result = @builder.build
    end

    it 'should fail' do
      @result.should be_false
    end

    it 'should say dockerfile not found' do
      @builder.errors[0].should include('no Dockerfile found')
    end
  end
end