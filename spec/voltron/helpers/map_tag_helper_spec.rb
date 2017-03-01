require 'rails_helper'

describe Voltron::Map::MapTagHelper do

  include ::ActionView::Helpers::AssetTagHelper

  before(:each) do
    WebMock.allow_net_connect!
  end
  
  it 'can generate an image tag with map src' do
    expect(map_tag('Denver, CO')).to eq('<img alt="Denver, CO" class="map-success" src="https://maps.googleapis.com/maps/api/staticmap?center=Denver%2C+CO&amp;key=AIzaSyCl-9y8w_ytBmC1hV1otWRBOB_N1rWub8Y&amp;size=500x500&amp;zoom=15" />')
  end

  it 'receives the defined address as the alt attribute by default' do
    expect(map_tag('Denver, CO')).to match(/alt="Denver, CO"/)
    expect(map_tag('Denver, CO', {}, { alt: 'Custom Alt' })).to match(/alt="Custom Alt"/)
  end

  it 'includes the map response as a data- attribute if any, and configured' do
    Voltron.config.map.include_response = true
    expect(map_tag('gdsagdsagdsagsdagdsagdsa')).to match(/data\-map\-response="Error geocoding: center"/)

    Voltron.config.map.include_response = false
    expect(map_tag('gdsagdsagdsagsdagdsagdsa')).to_not match(/data\-map\-response="Error geocoding: center"/)
  end

end
