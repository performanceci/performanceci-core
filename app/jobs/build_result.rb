
class BuildResult
  attr_reader :build
  def initialize(test_configuration, build)
    @test_configuration = test_configuration
    @build = build
  end

  def add_errors(errors)
  end

  def save
    puts "SAVING #{@results.to_json}"
    @results.each do |endpoint_attribs|
      attribs = endpoint_attribs.clone
      results = endpoint_attribs[:results]
      attribs.delete(:results)
      attribs.delete(:uri)
      attribs.delete(:headers)
      puts "ATTRIBS ARE: #{attribs}"
      endpoint = build.add_endpoint(endpoint_attribs[:uri], endpoint_attribs[:headers], attribs)
      build.endpoint_benchmark(endpoint, results['latencies']['mean'] / 1_000_000_000.to_f, 0, results)
    end

  end

  def test_results=(results)
    @results = results
  end
end