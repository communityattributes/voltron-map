module Voltron
  module Map
    module Generators
      module Install
        class AssetsGenerator < Rails::Generators::Base

          # Expand to root of gem, all paths will be built from there
          source_root File.expand_path('../../../../../../', __FILE__)

          desc 'Install Voltron Map assets'

          def copy_javascripts_assets
            copy_file 'app/assets/javascripts/voltron-map.js', Rails.root.join('app', 'assets', 'javascripts', 'voltron-map.js')
          end

        end
      end
    end
  end
end
