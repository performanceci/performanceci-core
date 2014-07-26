require 'fileutils'

class LocalCheckout
  attr_reader :build_dir, :repo_dir

  def initialize(repo_name, repo_dir)
    @repo_dir = repo_dir
  end

  def retrieve
    @build_dir = Dir.mktmpdir
    `cp -R #{repo_dir} #{build_dir}`
  end

  def source_dir
    build_dir
  end

  def errors
    []
  end

  def cleanup
    if build_dir && Dir.exists?(build_dir)
      FileUtils.remove_entry_secure build_dir
    end
  end
end