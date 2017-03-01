require 'rails_helper'

describe Voltron::Map::Image do

  before(:each) do
    WebMock.allow_net_connect!
  end

  it 'can generate a map url' do
    image = Voltron::Map::Image.new('Denver, CO')
    expect(image.url).to eq('https://maps.googleapis.com/maps/api/staticmap?center=Denver%2C+CO&key=AIzaSyCl-9y8w_ytBmC1hV1otWRBOB_N1rWub8Y&size=500x500&zoom=15')
  end

  it 'has a message if the request was invalid' do
    image = Voltron::Map::Image.new('Denver, CO', { key: 'abc' })
    expect(image.has_message?).to eq(true)
  end

  it 'includes the appropriate class name depending on map response' do
    image = Voltron::Map::Image.new('Denver, CO')
    expect(image.class_name).to eq('map-success')

    Voltron.config.map.fail_on_warning = false
    image = Voltron::Map::Image.new('Denver, CO') { marker 'gdsgadsagdsagsdgdsa' }
    expect(image.class_name).to eq('map-warning')

    image = Voltron::Map::Image.new('Denver, CO', { key: 'abc' })
    expect(image.class_name).to eq('map-invalid')

    Voltron.config.map.fail_on_warning = true
    image = Voltron::Map::Image.new('hfdhfdhfdshfdhfdshfdhfds')
    expect(image.class_name).to eq('map-error')
  end

  it 'has the appropriate state depending on map response' do
    image = Voltron::Map::Image.new('Denver, CO')
    expect(image.state).to eq(:success)

    Voltron.config.map.fail_on_warning = false
    image = Voltron::Map::Image.new('Denver, CO') { marker 'gdsgadsagdsagsdgdsa' }
    expect(image.state).to eq(:warning)

    image = Voltron::Map::Image.new('Denver, CO', { key: 'abc' })
    expect(image.state).to eq(:invalid)

    Voltron.config.map.fail_on_warning = true
    image = Voltron::Map::Image.new('hfdhfdhfdshfdhfdshfdhfds')
    expect(image.state).to eq(:error)
  end

  it 'has an invalid state if server cannot be reached' do
    WebMock.disable_net_connect!
    stub_request(:get, "https://maps.googleapis.com/maps/api/staticmap?center=Denver,%20CO&key=AIzaSyCl-9y8w_ytBmC1hV1otWRBOB_N1rWub8Y&size=500x500&zoom=15")
      .with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'maps.googleapis.com', 'User-Agent'=>'Ruby'})
      .to_raise(StandardError)
    image = Voltron::Map::Image.new('Denver, CO')
    expect(image.state).to eq(:invalid)
  end

  it 'has a default fallback image' do
    Voltron.config.map.fallback_image = 'data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs='

    image = Voltron::Map::Image.new('Denver, CO', { key: 'abc' })
    expect(image.url).to eq('data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs=')
  end

  it 'can have a remote fallback image' do
    Voltron.config.map.fallback_image = 'https://images.unsplash.com/uploads/1413142095961484763cf/d141726c?dpr=1&auto=format&fit=crop&w=1500&h=1000&q=80&cs=tinysrgb'

    image = Voltron::Map::Image.new('Denver, CO', { key: 'abc' })
    expect(image.url).to eq('https://images.unsplash.com/uploads/1413142095961484763cf/d141726c?dpr=1&auto=format&fit=crop&w=1500&h=1000&q=80&cs=tinysrgb')
  end

  it 'can have a fallback image from assets' do
    Voltron.config.map.fallback_image = '3.jpg'

    image = Voltron::Map::Image.new('Denver, CO', { key: 'abc' })
    expect(image.url).to match(/\/assets\/3\-[a-z0-9]+\.jpg/)
  end

  context 'with path' do

    it 'can draw a path' do
      image = Voltron::Map::Image.new('Colorado') do
        path 'Denver, CO', 'Pueblo, CO', [39.481654, -106.038352], 'Denver, CO'
      end

      expect(image.state).to eq(:success)
      expect(image.url).to match(/path=Denver%2C\+CO%7CPueblo%2C\+CO%7C39\.481654%2C\-106\.038352%7CDenver%2C\+CO/)
    end

  end

  context 'with marker' do

    it 'can draw a marker' do
      image = Voltron::Map::Image.new('Denver, CO') do
        marker
      end

      expect(image.state).to eq(:success)
      expect(image.url).to match(/markers=Denver%2C\+CO/)
    end

  end

  context 'with visible location' do

    it 'will include a location marked as visible' do
      image = Voltron::Map::Image.new('Denver, CO') do
        visible 'Castle Rock, CO'
      end

      expect(image.state).to eq(:success)
      expect(image.url).to match(/visible=Castle\+Rock%2C\+CO/)
    end

  end

  context 'with style' do

    it 'can style a map' do
      image = Voltron::Map::Image.new('Denver, CO') do
        style 'road.local', 'geometry', visibility: :simplified, color: '0xc280e9'
      end

      expect(image.state).to eq(:success)
      expect(image.url).to match(/style=feature%3Aroad\.local%7Celement%3Ageometry%7Cvisibility%3Asimplified%7Ccolor%3A0xc280e9/)
    end

  end

end