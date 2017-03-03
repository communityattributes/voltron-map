require 'rails_helper'

describe Voltron::Map::MapUrlHelper do

  include ::Voltron::Map::MapUrlHelper

  before(:each) do
    WebMock.allow_net_connect!
  end
  
  it 'can generate a map url' do
    expect(map_url('Denver, CO')).to eq('https://maps.googleapis.com/maps/api/staticmap?center=Denver%2C+CO&key=AIzaSyCl-9y8w_ytBmC1hV1otWRBOB_N1rWub8Y&size=500x500&zoom=15')
  end

end
