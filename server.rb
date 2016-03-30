require 'sinatra/base'
require 'rack/throttle'
require 'json'
require 'active_support/all'
require 'http'
require 'mini_cache'

STORE = MiniCache::Store.new

module ScreendoorAppointmentDropdown
  class App < Sinatra::Base
    configure :development do
      require 'dotenv'
      Dotenv.load
    end

    configure :production do
      use Rack::Throttle::Interval
    end

    before do
      content_type :json
    end

    get '/' do
      # Cache every 5 minutes
      STORE.get_or_set "slots-#{rounded_time_for_cache}" do
        (available_slots - taken_slots).to_json
      end
    end

    get '/ping' do
      {
        pong: true
      }.to_json
    end

    # Dates must be at least one week in the future
    def start_date
      Date.today + 1.week
    end

    # Can't schedule more than one month in advance
    def end_date
      Date.today + 1.month
    end

    def days_of_week
      %w(monday tuesday)
    end

    def timeslots
      %w(
        1:00pm
        1:30pm
        2:00pm
        2:30pm
        3:00pm
        3:30pm
      )
    end

    def available_slots
      [].tap do |arr|
        (start_date..end_date).each do |date|
          if Date::DAYNAMES[date.wday].downcase.in? days_of_week
            timeslots.each do |timeslot|
              # Don't change this format after responses have been submitted!
              arr << "#{date.strftime("%A, %b %-d")} - #{timeslot}"
            end
          end
        end
      end
    end

    def screendoor_responses
      HTTP.get(
        "https://screendoor.dobt.co/api/projects/#{ENV.fetch('SCREENDOOR_PROJECT_ID')}/responses",
        params: {
          v: 0,
          api_key: ENV.fetch('SCREENDOOR_API_KEY'),
          columns: "id,responses.#{ENV.fetch('SCREENDOOR_RESPONSE_FIELD_ID')}",
          per_page: 100,
          advanced_search: [
            {
              name: 'status',
              method: 'is_not',
              value: ENV.fetch('SCREENDOOR_ARCHIVED_STATUS_ID')
            }
          ].to_json
        }
      )
    end

    def taken_slots
      plucked = JSON.parse(screendoor_responses).to_a.map do |h|
        h['responses'][ENV.fetch('SCREENDOOR_RESPONSE_FIELD_ID')]
      end.compact
    end

    def rounded_time_for_cache
      time = Time.now
      step = 5 * 60
      Time.at((time.to_r / step).round * step).utc.to_s
    end
  end
end
