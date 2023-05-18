defmodule Noaa.CLI do


  import Noaa.TableFormatter, only: [ print_table_for_columns: 2 ]

  @moduledoc """
    Handle command line parsing and the dispatch to the various functions
    that end up generating a table of all the atmospheric conditions
    for the specified state and location
  """

  def main(argv) do
    argv
    |> parse_args()
    |> process()
  end

  @doc """
    `argv` can be -h or --help, which returns :help.

    Otherwise it is a NOAA location.

    Return a tupe of `{location}`, or `:help` if help was given.
  """

  def parse_args(argv) do
    OptionParser.parse(argv, switches:  [ help: :boolean],
                             aliases:   [ h:    :help   ])
    |> internal_args()
  end

  def process(:help) do
    IO.puts """
    usage: naoo <location>
    """

    System.halt(0)
  end

  def process({location}) do
    Noaa.NoaaIssues.fetch(location)
    |> decode_response()
    |> print_table_for_columns(["weather", "temperature_string", "dewpoint_string", "relative_humidity", "wind_string", "visibility_mi", "pressure_mb", "pressure_in", "observation_time", "observation_time_rfc822"])
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts "Error fetching from Github: #{error["message"]}"
    System.halt(2)
  end


  def internal_args({ [ help: true ], _, _}) do
    :help
  end

  def internal_args({_, [location], _}) do
    { location }
  end

  def internal_args({_, [ help: :boolean ], _}) do
    :help
  end

  def internal_args(_) do
    :help
  end
end
