defmodule Day2 do
  @spec letter_counts(String.t()) :: {non_neg_integer(), non_neg_integer()}
  def letter_counts(id) do
    id
    |> String.codepoints()
    |> Enum.reduce(%{}, fn letter, counts ->
      counts
      |> Map.update(letter, 1, & &1 + 1)
    end)
    |> Enum.reduce_while({0, 0}, fn
      {_, 2}, {0, _} = acc ->
        {:cont, put_elem(acc, 0, 1)}

      {_, 3}, {_, 0} = acc ->
        {:cont, put_elem(acc, 1, 1)}

      _, {1, 1} = acc ->
        {:halt, acc}

      _, acc ->
        {:cont, acc}
    end)
  end

  def checksum(data) do
    counts =
      data
      |> Enum.map(&Day2.letter_counts/1)
      |> Enum.reduce({0, 0}, fn {two_a, three_a}, {two_b, three_b} = acc ->
        acc
        |> put_elem(0, two_a + two_b)
        |> put_elem(1, three_a + three_b)
      end)

    elem(counts, 0) * elem(counts, 1)
  end

  def find_similar_id(data) do
    data
    |> Enum.sort()
    |> Enum.chunk_every(2)
    |> Enum.reduce_while("", fn
      [a, b], acc ->
        sim = extract_similar(a, b)
        if String.length(sim) == String.length(a) - 1 do
          {:halt, sim}
        else
          {:cont, acc}
        end

      _, acc ->
        acc
    end)
  end

  defp extract_similar(string_1, string_2) do
    string_1
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce_while({[], 0}, fn
      {graph, indx}, {chars, count} when count in [0, 1] ->
        if graph == String.at(string_2, indx) do
          {:cont, {[graph | chars], count}}
        else
          {:cont, {chars, count + 1}}
        end

      _, acc ->
        {:halt, acc}
    end)
    |> elem(0)
    |> :lists.reverse()
    |> to_string()
  end
end

data =
  IO.stream(:stdio, :line)
  |> Stream.map(&String.trim/1)
  |> Enum.to_list()

data
|> Day2.checksum()
|> IO.puts()

data
|> Day2.find_similar_id()
|> IO.puts()

