defmodule Noaa.TableFormatter do
  import Enum

  def print_table_for_columns(rows, header) do
    with  {:ok, clear_header}     <- clean_header(header),
          {:ok, table}            <- access_table(rows),
          {:ok, table_content}    <- content_extractor(header, clear_header, table),
          {:ok, table_all_string} <- table_string(table_content),
          {:ok, table_length}     <- table_length_calculator(table_all_string)
     do

      table_content
      |> IO.inspect(label: "table content")

      table_all_string
      |> IO.inspect(label: "the value of table_all_string is: ")

      table_length
      |> IO.inspect(label: "the value of table_length is: ")

    end
  end

  def table_length_calculator(table_all_string) do
    table_all_string
    |> IO.inspect(label: "the value of table_all_string is: ")

    # why not a list error?

    # {:ok, Enum.map(table_all_string, fn {key, value} -> Enum.max(length(key), length(value))end)}
  end

  def table_string(table_content) do
    {:ok, Enum.map(table_content, fn {key, value} -> {Atom.to_string(key), value} end)}
  end

  def content_extractor(header, clear_header, content) do
      data_extracted =
        for counter <- 0..length(header) - 3 do
          {String.to_atom(Enum.at(clear_header, counter)), content[Enum.at(header, counter)]}
        end

      data_refined =
        data_extracted ++ [{:last_updated, "#{content[Enum.at(header, length(header) - 2)]}\n#{content[Enum.at(header, length(header) - 1)]}"}]

      {:ok, data_refined}
  end

  def clean_header(header) do
    {:ok, Enum.map(header, fn element -> Enum.at(String.split(element, "_string", trim: true), 0) end)}
  end

  def access_table(rows) do
    {:ok, rows["current_observation"]["#content"]}
  end

end
