defmodule Noaa.TableFormatter do
  import Enum

  def print_table_for_columns(rows, header) do
    with  {:ok, clear_header}   <- clean_header(header),
          {:ok, table_content}          <- rows["current_observation"]["#content"],
          {:ok, table_content}  <- content_extractor(header, rows)
     do
      access_table(rows, Enum.at(header, 0)) |> IO.inspect(label: "#content_test")

      # table = rows["current_observation"]["#content"]
      table
      |> IO.inspect(label: "table content")
      # Enum.at(header_element, 0)
    end
  end

  def content_extractor(header, rows) do
    {:ok, "test"}
  end

  def clean_header(header) do
    {:ok, Enum.map(header, fn element -> Enum.at(String.split(element, "_string", trim: true), 0) end)}
  end

  def access_table(rows) do
    {:ok, rows["current_observation"]["#content"]}
  end

end
