defmodule CliTest do
  use ExUnit.Case
  doctest Noaa

  import Noaa.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  # test "three values returned if three given" do
  #   assert parse_args(["user", "California", "Alturas"]) ==
  #     {"user", "California", "Alturas"}
  # end

  # test "two values returned if two given" do
  #   assert parse_args(["user", "California"]) ==
  #     {"user", "California"}
  # end

  test "one values returned if one given" do
    assert parse_args(["KAAT"]) ==
      {"KAAT"}
  end

  test ":help returned if anything given" do
    assert parse_args(["-h"])    == :help
    assert parse_args(["-help"]) == :help
  end

end
