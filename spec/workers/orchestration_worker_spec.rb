require 'spec_helper'

describe OrchestrationWorker do
  let!(:build) { Build.create(:repository => Repository.create!) }

  let(:configuration) do
    { :port => '1234' }
  end

  before do
    ProjectConfiguration.any_instance.stub(:configuration).and_return(configuration)
  end

  describe "error scenarios" do
    it "should handle failed to checkout" do
      GitCheckout.any_instance.should_receive(:retrieve).and_return(false)
      GitCheckout.any_instance.stub(:errors).and_return(["error"])
      GitCheckout.any_instance.should_receive(:cleanup)
      BuildResult.any_instance.should_receive(:add_errors)
      BuildResult.any_instance.should_receive(:save)
      lambda {
        OrchestrationWorker.new("1234", {'build_id' => build.id}).safe_perform!
      }.should raise_exception
    end

    it "should handle failed paas build" do
      GitCheckout.any_instance.should_receive(:retrieve).and_return(true)
      ProjectConfiguration.should_receive(:from_build_dir).and_return(ProjectConfiguration.new(nil))
      DockerBuilder.any_instance.should_receive(:build).and_return(false)
      GitCheckout.any_instance.should_receive(:cleanup)
      DockerBuilder.any_instance.should_receive(:cleanup)

      BuildResult.any_instance.should_receive(:add_errors)
      BuildResult.any_instance.should_receive(:save)
      lambda {
        OrchestrationWorker.new("1234", {'build_id' => build.id}).safe_perform!
      }.should raise_exception
    end

    it "should handle failed project configuration" do
      GitCheckout.any_instance.should_receive(:retrieve).and_return(true)
      ProjectConfiguration.should_receive(:from_build_dir).and_return(ProjectConfiguration.new(nil))
      ProjectConfiguration.any_instance.should_receive(:valid?).and_return(false)

      GitCheckout.any_instance.should_receive(:cleanup)

      BuildResult.any_instance.should_receive(:add_errors)
      BuildResult.any_instance.should_receive(:save)

      lambda {
        OrchestrationWorker.new("1234", {'build_id' => build.id}).safe_perform!
      }.should raise_exception
    end

    it "should handle failed load test" do
      GitCheckout.any_instance.should_receive(:retrieve).and_return(true)
      DockerBuilder.any_instance.should_receive(:build).and_return(true)
      DockerBuilder.any_instance.should_receive(:container_name).and_return('foo')
      ProjectConfiguration.should_receive(:from_build_dir).and_return(ProjectConfiguration.new(nil))
      HttpLoadTester.any_instance.should_receive(:run).and_return(false)

      GitCheckout.any_instance.should_receive(:cleanup)
      DockerBuilder.any_instance.should_receive(:cleanup)
      HttpLoadTester.any_instance.should_receive(:cleanup)

      BuildResult.any_instance.should_receive(:add_errors)
      BuildResult.any_instance.should_receive(:save)

      lambda {
        OrchestrationWorker.new("1234", {'build_id' => build.id}).safe_perform!
      }.should raise_exception
    end

  end

  it "should work with successful flow" do
    GitCheckout.any_instance.should_receive(:retrieve).and_return(true)
    DockerBuilder.any_instance.should_receive(:build).and_return(true)
    DockerBuilder.any_instance.should_receive(:container_name).and_return('foo')
    ProjectConfiguration.should_receive(:from_build_dir).and_return(ProjectConfiguration.new(nil))
    HttpLoadTester.any_instance.should_receive(:run).and_return(true)
    BuildResult.any_instance.should_receive(:save)
    GitCheckout.any_instance.should_receive(:cleanup)
    HttpLoadTester.any_instance.should_receive(:cleanup)
    DockerBuilder.any_instance.should_receive(:cleanup)
    OrchestrationWorker.new("1234", {'build_id' => build.id}).safe_perform!
  end

  context "docker provider" do
    it "should work with docker provider" do
      Build.any_instance.should_receive(:provider).and_return(:docker)
      GitCheckout.any_instance.should_receive(:retrieve).and_return(true)
      DockerBuilder.any_instance.should_receive(:build).and_return(true)
      DockerBuilder.any_instance.should_receive(:container_name).and_return('blah')
      ProjectConfiguration.should_receive(:from_build_dir).and_return(ProjectConfiguration.new(nil))
      HttpLoadTester.any_instance.should_receive(:run).and_return(true)
      BuildResult.any_instance.should_receive(:save)
      GitCheckout.any_instance.should_receive(:cleanup)
      HttpLoadTester.any_instance.should_receive(:cleanup)
      DockerBuilder.any_instance.should_receive(:cleanup)
      OrchestrationWorker.new("1234", {'build_id' => build.id}).safe_perform!
    end
  end

  context "local checkout" do
    before do
      ENV['LOCAL_WORKSPACE'] = 'true'
    end

    after do
      ENV['LOCAL_WORKSPACE'] = nil
    end

    it "should work with local checkout" do
      LocalCheckout.any_instance.should_receive(:retrieve).and_return(true)
      DockerBuilder.any_instance.should_receive(:build).and_return(true)
      DockerBuilder.any_instance.should_receive(:container_name).and_return('foo')
      ProjectConfiguration.should_receive(:from_build_dir).and_return(ProjectConfiguration.new(nil))
      HttpLoadTester.any_instance.should_receive(:run).and_return(true)
      BuildResult.any_instance.should_receive(:save)
      LocalCheckout.any_instance.should_receive(:cleanup)
      HttpLoadTester.any_instance.should_receive(:cleanup)
      DockerBuilder.any_instance.should_receive(:cleanup)
      OrchestrationWorker.new("1234", {'build_id' => build.id}).safe_perform!
    end
  end
end