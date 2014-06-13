require 'spec_helper'

#TODO: Shared context
describe HttpLoadTester do
  def docker_builder(project_path)
    path = File.join(File.dirname(__FILE__), project_path)
    @test_config = ProjectConfiguration.from_build_dir(path)
    DockerBuilder.new(path, @test_config)
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

    it 'should run running container' do
      load_tester = HttpLoadTester.new({link_container_name: @builder.container_name}, @test_config)
      load_tester.run.should_not be_nil
      results = load_tester.test_results
      puts results.to_json
      results.all? { |t| t['success'] == 1 }.should be_true
    end
  end
end