require 'sinatra'
require 'json'
require 'http'

# Replace with your OpenWeatherMap API key
API_KEY = '1'

# Define the base URL for the weather API
BASE_URL = 'http://api.openweathermap.org/data/2.5/weather'

# Helper method to fetch weather data
def fetch_weather(city)
  # Make the request to the weather API
  response = HTTP.get(BASE_URL, params: {
    q: city,
    appid: API_KEY,
    units: 'metric' # metric = Celsius
  })

  # Parse the response as JSON
  JSON.parse(response.body.to_s)
end

# Route to handle weather requests
get '/weather' do
  content_type :json

  # Get the city parameter from the query string
  city = params['city']

  # Check if a city was provided
  if city.nil? || city.empty?
    status 400
    return { error: 'City parameter is required' }.to_json
  end

  # Fetch weather data
  begin
    weather_data = fetch_weather(city)

    # Check if the API returned an error (e.g., city not found)
    if weather_data['cod'] != 200
      status weather_data['cod']
      return { error: weather_data['message'] }.to_json
    end

    # Respond with the relevant weather data
    {
      city: weather_data['name'],
      temperature: weather_data['main']['temp'],
      description: weather_data['weather'][0]['description']
    }.to_json
  rescue => e
    status 500
    { error: 'Unable to fetch weather data', details: e.message }.to_json
  end
end
