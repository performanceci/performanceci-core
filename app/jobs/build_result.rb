
class BuildResult
  attr_reader :build, :errors
  attr_accessor :test_configuration
  def initialize(build)
    @build = build
    @errors = []
  end

  def add_errors(more_errors)
    errors.concat more_errors
  end

  def save
    puts "SAVING #{@results.to_json}"
    if errors.empty?
      @results.each do |endpoint_attribs|
        attribs = endpoint_attribs.clone
        results = endpoint_attribs[:results]
        attribs.delete(:results)
        attribs.delete(:uri)
        attribs.delete(:headers)
        endpoint = build.add_endpoint(endpoint_attribs[:uri], endpoint_attribs[:headers], attribs)
        build.endpoint_benchmark(endpoint, results[:latencies][:mean] / 1_000_000_000.to_f, 0, results)
      end
    else
      build.mark_build_error(errors.join("\n"))
    end

  end

  def test_results=(results)
    @results = results
  end
end