defmodule Noaa.TableFormatter do
  import Enum

  def print_table_for_columns(rows, header) do
    with  {:ok, clear_header}     <- clean_header(header),
          {:ok, table}            <- access_table(rows),
          {:ok, table_content}    <- content_extractor(header, clear_header, table),
          {:ok, table_all_string} <- table_string(table_content),
          {:ok, table_length}     <- table_length_calculator(table_all_string),
          {:ok, table_formatted}  <- table_formater(table_all_string, table_length)
     do

      table_all_string
      |> IO.inspect(label: "the value of table_all_string is: ")

      table_length
      |> IO.inspect(label: "the value of table_length is: ")

    end
  end

  def border_formater(length), do: String.pad_leading("", length, "-")

  def side_length(content, length_size) do
    left_side_padding_size = Float.floor(length_size / 2, 0) - Float.floor(length(content) / 2, 0)
    right_side_padding_size = Float.round(length_size / 2, 0) - Float.round(length(content) / 2, 0)
    {:ok, [left_side_padding_size, right_side_padding_size]}
  end


  def side_formater(content, length_size) do
    with {:ok, side_length} = side_length(content, length_size) do
      String.pad_leading(content, Enum.at(side_length, 0) + 1 , " ") <> content <> String.pad_trailing(content, Enum.at(side_length, 1) + 1, " ") <> "|"
    end
  end

  def table_formater(table_all_string, table_length) do
    with border_length = Enum.sum(table_length) + 2 * length(table_length),
        border_string = border_formater(border_length) do
          border_string
          |> IO.inspect(label: "The value of border_string is: ")

          # format each word in the table

    end
  end

  def table_length_calculator(table_all_string) do
    {:ok, Enum.map(table_all_string,
      fn {key, value} ->
        value0 =
          String.split(value, "\n")
          |> Enum.at(0)
          |> String.length()

        value1 =
          String.split(value, "\n")
          |> Enum.at(1)
          |> value_nil
          |> String.length()

          Enum.max([String.length(key), value0 , value1])
      end)}
  end

  def value_nil(nil),   do: ""
  def value_nil(value), do: value

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
