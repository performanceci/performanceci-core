class EmptyCheckout
  def initialize(build)
    @build = build
  end

  def retrieve
    true
  end

  def source_dir
  end

  def project_configuration
    parsed_conf = JSON.parse(@build.repository.config)
    ProjectConfiguration.new(parsed_conf)
  end

  def errors
    []
  end

  def cleanup
  end
end