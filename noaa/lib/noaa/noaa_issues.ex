defmodule Noaa.NoaaIssues do

  require Logger

  @noaa_url Application.get_env(:noaa, :noaa_url)

  use HTTPoison.Base

  def fetch(location) do
    Logger.info("Fetching #{location}")

    noaa_url(location)
    |> HTTPoison.get
    |> handle_response
    |> convert_to_map
  end

  def noaa_url(location) do
    "#{@noaa_url}/#{location}.xml"
  end

  def handle_response({:ok, %{status_code: status_code, body: body}}) do
    Logger.info("Got response #{status_code}")
    Logger.debug(fn -> inspect(body) end)


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
