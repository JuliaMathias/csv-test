defmodule CsvTest.PlayerSeasonsTest do
  use CsvTest.RepoCase

  alias CsvTest.PlayerSeasons

  describe "populate_people_table_from_csv(file)" do
    test "when all entries in csv_files are valid, should populate successfully" do
      assert PlayerSeasons.populate_people_table_from_csv("players_seasons.csv") == :ok
    end
  end
end
