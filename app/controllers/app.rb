#  frozen_string_literal: true

require 'roda'
require 'slim'

module TrailSmith
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $stderr
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        view 'home'
      end

      routing.on 'location' do
        routing.is do
          # POST /location/
          routing.post do
            site = routing.params['query'].downcase

            routing.redirect "location/#{site}"
          end
        end

        routing.on String do |site|
          # GET /location/[site]
          routing.get do
            site_info = GoogleMaps::SpotMapper.new(GOOGLE_MAPS_KEY).find(site)

            view 'location', locals: { spot: site_info }
          end
        end
      end
    end
  end
end