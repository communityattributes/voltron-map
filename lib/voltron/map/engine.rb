module Voltron
  module Map
    class Engine < Rails::Engine

      isolate_namespace Voltron

      config.autoload_paths += Dir["#{config.root}/lib/**/"]

      initializer "voltron.map.initialize" do
        ::ActionView::Helpers.send :include, ::Voltron::Map::MapUrlHelper
        ::ActionView::Helpers.send :include, ::Voltron::Map::MapTagHelper
      end

    end
  end
end
