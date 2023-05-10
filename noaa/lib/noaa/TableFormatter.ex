defmodule Noaa.TableFormatter do
  import Enum

  def print_table_for_columns(rows, header) do
    rows    |> IO.inspect(label: "rows")
    header  |> IO.inspect(label: "header")
    access_table(rows, [Enum.at(header,0)]) |> IO.inspect(label: "#content_test")
  end

  def access_table(rows, header_element) do
    rows["current_observation"]["#content"][header_element]
  end

end
