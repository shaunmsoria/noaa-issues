defmodule Noaa.CLI do

  @moduledoc """
  Handle command line parsing and the dispatch to the various functions that end up generating a table of all the atmospheric conditions
  for the specified state and location
  """

  def run(argv) do
    parse_args(argv)
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a github user name, and optionally the state and location.

  Return a tupe of `{user, project, count}`, or `:help` if help was given.
  """

  def parse_args(argv) do
    OptionParser.parse(argv, switches:  [ help: :boolean],
                             aliases:   [ h:    :help   ])
    |> internal_args()
    # |> process()
  end

  def process(:help) do
    IO.puts """
    usage: naoo <user> <state> <city>
    """

    System.halt(0)
  end

  def process({user, state, city}) do
    # connecting to naoo to retrieve the data
  end


  def internal_args({ [ help: true ], _, _}) do
    :help
  end

  def internal_args({_, [user, state, city], _}) do
    { user, state, city }
  end

  def internal_args({_, [user, state], _}) do
    { user, state }
  end

  def internal_args({_, [ help: :boolean ], _}) do
    :help
  end

  def internal_args({_, [user], _}) do
    { user }
  end

  def internal_args(_) do
    :help
  end
end
