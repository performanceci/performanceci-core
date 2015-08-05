class ExternalBuilder

  def initialize(url, configuration)
    @url = url
  end

  def cleanup
  end

  def build
    true
  end

  def errors
    []
  end

  def base_test_url
    @url
  end
end