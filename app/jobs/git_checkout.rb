class GitCheckout
  attr_reader :repo_name, :repo_url, :build_dir, :errors, :commit_hash

  def initialize(repo_name, repo_url, commit_hash = nil)
    @repo_name = repo_name
    @repo_url = repo_url
    @commit_hash = commit_hash
    @errors = []
  end

  def retrieve
    @build_dir = Dir.mktmpdir
    g = Git.clone(repo_url, source_dir)
    g.checkout(commit_hash) if commit_hash
    true
  rescue Exception => e
    errors << e.to_s
    false
  end

  def source_dir
    "#{build_dir}/#{repo_name}"
  end

  def cleanup
    if build_dir && Dir.exists?(build_dir)
      FileUtils.remove_entry_secure build_dir
    end
  end
end