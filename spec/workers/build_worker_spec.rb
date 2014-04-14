require 'spec_helper'

describe BuildWorker do
  let!(:build) { Build.create }

  it "should perform" do
    BuildWorker.new("1234", {'build_id' => build.id}).safe_perform!
  end



end