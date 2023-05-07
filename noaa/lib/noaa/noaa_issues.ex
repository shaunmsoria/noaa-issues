defmodule Noaa.NoaaIssues do

  use HTTPoison.Base

  def fetch(_user, _state, location) do
    noaa_url(location)
    |> HTTPoison.get
    |> handle_response
    |> convert_to_map
  end

  def noaa_url(location) do
    "https://w1.weather.gov/xml/current_obs/#{location}.rss"
  end

  def handle_response({:ok, %{status_code: status_code, body: body}}) do
    {
      status_code |> check_for_errors(),
      body
    }
  end

  defp check_for_errors(200),  do: :ok
  defp check_for_errors(_),    do: :error

  def convert_to_map({:ok, xml_text}) do
   result =
    xml_text
    |> XmlToMap.naive_map()

  end

end
