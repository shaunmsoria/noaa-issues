defmodule Noaa.TableFormatter do
  import Enum

  def print_table_for_columns(rows, header) do
    with  {:ok, clear_header}   <- clean_header(header),
          {:ok, table}          <- access_table(rows),
          {:ok, table_content}  <- content_extractor(header, table)
     do

      table_content
      |> IO.inspect(label: "table content")

    end
  end

  def content_extractor(header, content) do
    with header_content <- Enum.map(header, content,
                                      fn header_element, content ->
                                        {header_element, content[header_element]} end)
    do
    {:ok, [header_content, header, content]}
    end
  end

  def clean_header(header) do
    {:ok, Enum.map(header, fn element -> Enum.at(String.split(element, "_string", trim: true), 0) end)}
  end

  def access_table(rows) do
    {:ok, rows["current_observation"]["#content"]}
  end

end
