class HttpLoadTester

  def initialize(paas_config, project_config)
    @driver = VegetaDriver.new(paas_config)
    @test_config = project_config
    @results = []
  end

  def run
    @results = @test_config.endpoints.each do |endpoint|
      endpoint[:results] = @driver.run_test(endpoint[:uri], endpoint[:concurrency], endpoint[:duration])
      puts "RESULTS: #{endpoint[:results]}"
    end
    @results
  end

  def errors
  end

  def cleanup
  end

  def test_results
    @results
  end
end