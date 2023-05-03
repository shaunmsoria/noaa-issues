defmodule Noaa.NoaaIssues do

  def fetch(_user, state, location) do
    noaa_url(location)
    |> HTTPoison.get
    |> handle_response
  end

  def noaa_url(location) do
    "https://w1.weather.gov/xml/current_obs/#{location}"
  end
end
