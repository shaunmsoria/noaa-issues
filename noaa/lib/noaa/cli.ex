defmodule Noaa.CLI do

  @moduledoc """
  Handle command line parsing and the dispatch to the various functions
  that end up generating a table of all the atmospheric conditions
  for the specified state and location
  """

  def run(argv) do
    parse_args(argv)
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
    |> process()
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
    |> IO.inspect()
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
