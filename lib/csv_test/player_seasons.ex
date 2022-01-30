defmodule CsvTest.PlayerSeasons do
  @moduledoc """
  -----
  """

  alias CsvTest.PlayerSeason

  def populate_people_table_from_csv(file) do
    File.stream!(file)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map_every(1, fn line -> String.split(line) end)
    |> Stream.map_every(1, fn element -> process_entry(element) end)
    |> Enum.to_list()

    # |> Enum.filter(fn x -> x != :ok end)
    # |> case do
    #   [] -> :ok
    #   list_of_errors -> list_of_errors
    # end
  end

  defp process_entry(entry) do
    readable_entry =
      entry
      |> List.to_string()
      |> String.replace("\"", "")
      |> String.replace_leading("{", "")
      |> String.replace_trailing(",", "")

    if readable_entry ==
         "total_seniors,club_seniors,national_teams_seniors,club_youth_honours,national_team_youth_honours,career_stats,player_id,club_id" do
      :ok
    else
      [
        total_seniors,
        club_seniors,
        national_team_seniors,
        club_youth_honours | rest_of_columns
      ] = String.split(readable_entry, "},{")

      %{
        total_seniors: total_seniors,
        club_seniors: club_seniors,
        national_team_seniors: national_team_seniors,
        club_youth_honours: club_youth_honours,
        national_team_youth_honours: get_national_team_honours(rest_of_columns),
        rest: rest_of_columns,
        career_stats: get_career_stats(rest_of_columns),
        player_id: get_player_id(rest_of_columns)
        # club_id: club_id
      }

      # |> CsvTest.Repo.insert()
      # |> case do
      #   {:ok, _player_season} -> :ok
      #   error -> error
      # end
    end
  end

  defp normalize_map_entries(entry) do
    if entry == "{}" do
      %{}
    else
      entry
      |> String.split(",")
    end
  end

  defp get_national_team_honours([first | _rest]), do: String.split(first, "},") |> List.first()

  defp get_player_id(list) do
    list |> List.to_string() |> String.split(",") |> List.last()
  end

  defp get_career_stats(list) do
    rest =
      list
      |> Enum.drop(1)
      |> List.first()
      |> String.split(",")
  end

  defp get_first_career_stat([head | _tail]) do
    head
    |> String.split("},[")
    |> List.first()
  end
end
