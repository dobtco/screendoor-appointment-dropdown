require 'sinatra/base'
require 'rack/throttle'
require 'json'

module ScreendoorAppointmentDropdown
  class App < Sinatra::Base
    configure :development do
      require 'dotenv'
      Dotenv.load
    end

    configure :production do
      use Rack::Throttle::Interval
    end

    get '/ping' do
      content_type :json

      {
        pong: true
      }.to_json
    end
  end
end
