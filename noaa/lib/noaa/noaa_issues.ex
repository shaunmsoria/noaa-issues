defmodule Noaa.NoaaIssues do
  @noaa_url Application.get_env(:noaa, :noaa_url)

  use HTTPoison.Base

  def fetch(location) do
    noaa_url(location)
    |> HTTPoison.get
    |> handle_response
    |> convert_to_map
  end

  def noaa_url(location) do
    "#{@github_url}/#{location}.rss"
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
    {
      :ok,
      xml_text
      |> XmlToMap.naive_map()
    }
  end

  def convert_to_map({_, body}) do
    {:error, body}
  end

end
