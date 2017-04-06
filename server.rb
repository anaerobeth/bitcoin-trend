require 'sinatra'
require 'json'
require 'net/http'

post '/' do
  # Connect to a server that retrieves Google Trend data for 'Bitcoin'
  message = Net::HTTP.get(URI.parse("http://localhost:4000"))
  timeline = JSON.parse(message)["default"]["timelineData"]
  yesterday = timeline[-1]["value"][0]
  last_week = timeline[0]["value"][0]
  difference = yesterday - last_week
  message = case difference
            when > 5:
              'More '
            when < -5:
              'Fewer '
            else:
              'The same number of'
            end
  message << 'people searched for bitcoin on Google Trends yesterday than last week'

  to_json(message)
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

