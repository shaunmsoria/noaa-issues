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
    left_side_padding_size = trunc(length_size / 2) - trunc(String.length(content) / 2)
    right_side_padding_size = round(length_size / 2) - round(String.length(content) / 2)
    {:ok, [abs(left_side_padding_size), abs(right_side_padding_size)]}
  end


  def side_formater(content, length_size) do
    with {:ok, side_length} = side_length(content, length_size) do
      String.pad_leading("", Enum.at(side_length, 0) + 1, " ") <> content <> String.pad_trailing("", Enum.at(side_length, 1) + 1 , " ") <> "|"
    end
  end

  def header_formater(table_all_string, table_length, border_length) do
    with  table_header          = Enum.map(table_all_string, fn {key, value} -> key end),
          header_length_zipped  = Enum.zip(table_header, table_length)
    do
    {:ok,
      [
        border_formater(border_length),
        Enum.reduce(header_length_zipped, "|",
          fn head_length, acc ->
            {head, length} = head_length
            acc <> side_formater(head, length)
          end),
        border_formater(border_length)
      ]
    }
    end
  end

  def body_formater(table_all_string, table_length, border_length) do
    with  table_body          = Enum.map(table_all_string, fn {key, value} -> value end),
          body_length_zipped  = Enum.zip(table_body, table_length)
    do
    {:ok,
      [
        Enum.reduce(body_length_zipped, "|",
          fn body_length, acc ->
            {body, length} = body_length
            acc <> side_formater(body, length)
          end),
        border_formater(border_length)
      ]
    }
    end
  end

  def table_formater(table_all_string, table_length) do
    with  border_length       = Enum.sum(table_length) + (3 * length(table_length)) + 1,
          border_string       = border_formater(border_length),
          {:ok, table_header} = header_formater(table_all_string, table_length, border_length),
          {:ok, table_body}   = body_formater(table_all_string, table_length, border_length)
    do

          Enum.map(table_header ++ table_body, fn element -> IO.puts(element) end)
    end
  end

  def table_length_calculator(table_all_string) do
    {:ok, Enum.map(table_all_string,
      fn {key, value} ->

        Enum.max([String.length(key), String.length(value)])
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
        data_extracted ++ [{:last_updated, "#{content[Enum.at(header, length(header) - 2)]} #{content[Enum.at(header, length(header) - 1)]}"}]

      {:ok, data_refined}
  end

  def clean_header(header) do
    {:ok, Enum.map(header, fn element -> Enum.at(String.split(element, "_string", trim: true), 0) end)}
  end

  def access_table(rows) do
    {:ok, rows["current_observation"]["#content"]}
  end

end
