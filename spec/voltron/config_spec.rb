require 'spec_helper'

describe Voltron::Config do

  it 'includes the map api key in the Voltron config json' do
    expect(Voltron.config.to_h[:map][:key]).to eq('AIzaSyCl-9y8w_ytBmC1hV1otWRBOB_N1rWub8Y')
  end

end