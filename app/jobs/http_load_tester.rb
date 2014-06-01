#docker run vegeta echo "GET http://localhost/" | vegeta attack -duration=5s | tee results.bin | vegeta report -reporter=json
#docker run vegeta echo "GET http://www.yahoo.com" | vegeta attack -duration=5s -rate=2 | tee results.bin | vegeta report -reporter=json
#echo "GET $(echo $TEST_HOST_PORT | sed 's/tcp/http/')" | ./vegeta attack -duration=5s -rate=2 | tee results.bin | ./vegeta report -reporter=json
#santize input

#IF linking:
#HUT_PORT - gsub tcp: http:
#give it random name

#TODO: structs for endpoints (?)
class HttpLoadTester

  def initialize(paas_config, project_config)
    @driver = VegetaDriver.new(paas_config)
    @test_config = project_config
    @results = []
  end

  def run
    @results = @test_config.endpoints.map do |endpoint|
      puts "ENDPOINT: #{endpoint}"
      @driver.run_test(endpoint[:uri], endpoint[:concurrency], endpoint[:duration])
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