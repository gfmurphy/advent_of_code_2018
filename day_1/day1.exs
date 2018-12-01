data =
  IO.stream(:stdio, :line)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.to_integer/1)
  |> Enum.to_list()

defmodule Day1 do
  def resulting_freq(data) do
    data
    |> Enum.sum()
  end

  def dup_freq({nil, _, %MapSet{}} = acc, data) do
    data
    |> Enum.reduce_while(acc, fn num, {dup, freq, counts} ->
      freq = num + freq
      if MapSet.member?(counts, freq) do
        {:halt, {freq, freq, counts}}
      else
        {:cont, {dup, freq, MapSet.put(counts, freq)}}
      end
    end)
    |> dup_freq(data)
  end

  def dup_freq({dup, _, _}, _), do: dup
end

Day1.resulting_freq(data)
|> IO.puts()

Day1.dup_freq({nil, 0, MapSet.new}, data)
|> IO.puts()
