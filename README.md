[![Coverage Status](https://coveralls.io/repos/github/ehainer/voltron-map/badge.svg?branch=master)](https://coveralls.io/github/ehainer/voltron-map?branch=master)
[![Build Status](https://travis-ci.org/ehainer/voltron-map.svg?branch=master)](https://travis-ci.org/ehainer/voltron-map)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

# Voltron::Map

Trying to find an easier way to generate various Google Maps

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'voltron-map', '~> 0.1.2'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install voltron-map

Then run the following to create the voltron.rb initializer (if not exists already) and add the map config:

    $ rails g voltron:map:install

## Usage

To generate a static map image, you may simple call the `map_tag` method in your views.

```ruby
<%= map_tag(+address+, +options+, +image_options+) %>
```

Where `+address+` is a valid street address or location ('Denver, CO' for example) or and array of [lat, long], or a comma separate list of lat,long.

+options+ are any of the "Map Parameters" defined on this page: https://developers.google.com/maps/documentation/static-maps/intro

+image_options+ is any valid option accepted in `image_tag`

Optionally, you may pass a black which allows you to define any "Feature Parameters" on this page: https://developers.google.com/maps/documentation/static-maps/intro

```ruby
<%= map_tag('Denver, CO', { size: 300, scale: 2, format: :png32, zoom: 12 }, { size: 300, alt: 'Home' }) do

  # marker(+address+, +options+)
  # Passed with no arguments places a standard marker on the maps initial address, in this case, "Denver, CO"
  marker

  # Or define an address to mark, again as either a string address, string of "lat,long", or array as [lat, long],
  # followed by any marker options defined under "Marker Styles" here: https://developers.google.com/maps/documentation/static-maps/intro#Markers
  marker '600 S Broadway, Denver CO', color: :blue

  # path(+location+, +location+, +location+, ..., +options+)
  # Define a path, between multiple locations (for example: a line that goes from Denver to Castle Rock to Nederland to Fort Collins and back to Denver (closing the loop))
  # followed by any path options defined under "Path Styles" here: https://developers.google.com/maps/documentation/static-maps/intro#Paths
  path 'Denver, CO', 'Castle Rock, CO', 'Nederland, CO', 'Fort Collins, CO', 'Denver, CO', color: '0x234051', fillcolor: '0x00000033'

  # visible(+location+, +location+, +location+, ...)
  # Define one or more locations that should remain visible on the map, in the event that the given +map_tag+ params would result in it being cut off
  visible 'Colorado Springs, CO', 'Boulder, CO'

  # style(feature=all, element=all, rules)
  # Style a given part of the map with the provided rules (for example, simplify and make all local roads white on the map)
  style 'road.local', 'geometry', color: '0xFFFFFFF', visibility: :simplified

end %>
```

To generate just a map url, not within an `<img />` tag, you may use the `map_url` helper, which is identical to `map_tag` with the exception of the `image_options` argument. It still accepts a block to add markers/paths/styles/etc

```ruby
<%= map_url('Denver, CO') %>
```

## Options

You may define a set of default map parameters in the `config.map.defaults` hash within the voltron initializer. They will apply to all calls to `map_tag` or `map_url`, but be overridden if the same option is specified in the method argument itself.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ehainer/voltron-map. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.en.html).
