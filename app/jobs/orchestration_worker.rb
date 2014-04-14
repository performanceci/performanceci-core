class OrchestrationWorker < Worker
  include Resque::Plugins::Status
  @queue = "docker"

  def perform
    is_remote = !(ENV['LOCAL_WORKSPACE'] == 'true')
    build = Build.find(options['build_id'])
    build_and_test(build, :is_remote => is_remote)
  end

  def build_and_test(build, options = {})
    paas = nil
    project_checkout = nil
    load_tester = nil
    is_remote = options[:is_remote]

    begin
      update_status(build, :cloning, 1)
      build_results = BuildResult.new(build)
      project_checkout = project_fetcher(build, is_remote)
      unless project_checkout.retrieve
        execution_error(build_results, project_checkout.errors)
      end
      project_src = project_checkout.source_dir

      test_configuration = ProjectConfiguration.from_build_dir(project_src)
      build_results.test_configuration = test_configuration
      unless test_configuration.valid?
        execution_error(build_results, test_configuration.errors)
      end

      update_status(build, :building_container, 2)

      paas = paas_for_build(build, project_src, test_configuration)
      unless paas.build
        execution_error(build_results, paas.errors)
      end

      update_status(build, :attacking_container, 3)

      load_tester = HttpLoadTester.new(paas_configuration(paas), test_configuration)
      if load_tester.run
        build_results.test_results = load_tester.test_results

        update_status(build, :saving_results, 4)

        build_results.save
      else
        execution_error(build_results, load_tester.errors)
      end

    ensure

      project_checkout.cleanup rescue nil if project_checkout
      paas.cleanup rescue nil if paas
      load_tester.cleanup rescue nil if load_tester
    end

    build.mark_build_finished
  end

  def update_status(build, status, step, total = 6)
    #puts "UPDATING STATUS #{status} #{step}"
    at(step, total, status.to_s)
    build.update_status(status, step / total.to_f * 100)
  end

  def paas_for_build(build, project_src, test_configuration)
    if build.provider == :docker
      paas = DockerBuilder.new(project_src, test_configuration)
    else
      provider = build.repository.provider
      paas = HerokuBuilder.new(project_src, provider, test_configuration)
    end
  end

  def paas_configuration(paas)
    # configuration to hand to load tester
    if paas.is_a?(DockerBuilder)
      {link_container_name: paas.container_name}
    else
      {base_url: paas.base_test_url}
    end
  end

  def project_fetcher(build, is_remote)
    if is_remote
      project_checkout = GitCheckout.new(build.repository.full_name, build.url, build.after)
    else
      project_checkout = LocalCheckout.new(build.repository.full_name, build.url)
    end
  end

  def execution_error(build_results, errors)
    build_results.add_errors(errors)
    build_results.save
    raise Exception.new(errors.to_s)
  end
end
