defmodule Sorteio do
  def start(file_name) when is_binary(file_name) do #is_binary = string
    file_name
    |> File.read
    |> handle_file_read
  end

  defp handle_file_read({:ok, file}) do
    file
    |> String.replace(~r/\n$/,"")
    |> String.split("\n")
    |> tl()
    |> Enum.map(&manipulate_row/1)
    |> Enum.uniq_by(&(&1.href))
    |> Enum.random()
    |> get_results_phrase()
  end
  
  defp handle_file_read({:error, reason}), do: {:error, "Deu erro: #{reason}"} 
  
  defp manipulate_row(row) do
    row
    |> String.replace(~r/\r$/,"")
    |> String.split(";")
    |> manipulate_column()
  end

  defp manipulate_column(column) do
    [date, href, title, subTitle, isLiked] = column
    %{
      :date => date, 
      :href => href,
      :title => title, 
      :subTitle => subTitle, 
      :isLiked => isLiked,
    }
  end

  defp get_results_phrase(%{:title => title, :date => date}) do
    "Parabéns, você foi selecionado #{title} #{date}!"
  end  
end
