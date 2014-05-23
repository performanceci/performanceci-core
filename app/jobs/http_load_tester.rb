#docker run vegeta echo "GET http://localhost/" | vegeta attack -duration=5s | tee results.bin | vegeta report -reporter=json
#docker run vegeta echo "GET http://www.yahoo.com" | vegeta attack -duration=5s -rate=2 | tee results.bin | vegeta report -reporter=json
#echo "GET $(echo $TEST_HOST_PORT | sed 's/tcp/http/')" | ./vegeta attack -duration=5s -rate=2 | tee results.bin | ./vegeta report -reporter=json
#santize input

#IF linking:
#HUT_PORT - gsub tcp: http:
#give it random name

class HttpLoadTester

  def initialize(base_url, test_configuration, driver = nil)
    @driver = driver || VegetaDriver.new
    @base_url = base_url
    @test_configuration = test_configuration
  end

  def run
  end

  def errors
  end

  def cleanup
  end

  def test_results
  end
end