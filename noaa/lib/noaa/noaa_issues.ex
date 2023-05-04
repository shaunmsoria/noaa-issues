defmodule Noaa.NoaaIssues do

  use HTTPoison.Base

  def fetch(_user, _state, location) do
    noaa_url(location)
    |> HTTPoison.get
    |> handle_response
    |> convert_to_jason
  end

  def noaa_url(location) do
    "https://w1.weather.gov/xml/current_obs/#{location}.rss"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, body}
  end

  def handle_response({_, %{status_code: code, body: body}}) do
    {:error, body }
  end

  def convert_to_jason({:ok, xml_text}) do
   xml_text
   |> XmlToMap.naive_map()
   |> Poison.encode!()
   |> IO.inspect()

  end

end
