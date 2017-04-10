require 'sinatra'
require 'json'
require 'net/http'

post '/' do
  timeline = JSON.parse(data)["default"]["timelineData"]
  message = case trend_diff(timeline)
            when > 5:
              'More '
            when < -5:
              'Fewer '
            else:
              'The same number of '
            end
  message << 'people searched for bitcoin on Google yesterday than last week'

  to_json(message)
end

def data
  # Connect to a server that retrieves Google Trend data for 'Bitcoin'
  Net::HTTP.get(URI.parse("http://localhost:4000"))
end

def trend_diff(timeline)
  trend_yesterday = timeline[-1]["value"][0]
  trend_last_week = timeline[0]["value"][0]
  trend_yesterday - trend_last_week
end

def to_json(message)
  {
    version: "1.0",
    response: {
      outputSpeech: {
        type: "PlainText",
        text: message
      }
    }
  }.to_json
end

