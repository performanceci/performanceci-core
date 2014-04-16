class DockerBuilder
  attr_reader :src_dir

  def initialize(src_dir)
    @src_dir = src_dir
  end

  def cleanup
  end

  def build
  end

  def errors
  end

  def base_test_url
  end
end