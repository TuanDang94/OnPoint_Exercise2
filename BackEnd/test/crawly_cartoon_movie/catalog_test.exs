defmodule CrawlyCartoonMovie.CatalogTest do
  use CrawlyCartoonMovie.DataCase

  alias CrawlyCartoonMovie.Catalog

  describe "movie" do
    alias CrawlyCartoonMovie.Catalog.Movie

    import CrawlyCartoonMovie.CatalogFixtures

    @invalid_attrs %{full_series: nil, link: nil, num_of_episode: nil, thumnail: nil, title: nil, year: nil}

    test "list_movie/0 returns all movie" do
      movie = movie_fixture()
      assert Catalog.list_movie() == [movie]
    end

    test "get_movie!/1 returns the movie with given id" do
      movie = movie_fixture()
      assert Catalog.get_movie!(movie.id) == movie
    end

    test "create_movie/1 with valid data creates a movie" do
      valid_attrs = %{full_series: "some full_series", link: "some link", num_of_episode: "some num_of_episode", thumnail: "some thumnail", title: "some title", year: "some year"}

      assert {:ok, %Movie{} = movie} = Catalog.create_movie(valid_attrs)
      assert movie.full_series == "some full_series"
      assert movie.link == "some link"
      assert movie.num_of_episode == "some num_of_episode"
      assert movie.thumnail == "some thumnail"
      assert movie.title == "some title"
      assert movie.year == "some year"
    end

    test "create_movie/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_movie(@invalid_attrs)
    end

    test "update_movie/2 with valid data updates the movie" do
      movie = movie_fixture()
      update_attrs = %{full_series: "some updated full_series", link: "some updated link", num_of_episode: "some updated num_of_episode", thumnail: "some updated thumnail", title: "some updated title", year: "some updated year"}

      assert {:ok, %Movie{} = movie} = Catalog.update_movie(movie, update_attrs)
      assert movie.full_series == "some updated full_series"
      assert movie.link == "some updated link"
      assert movie.num_of_episode == "some updated num_of_episode"
      assert movie.thumnail == "some updated thumnail"
      assert movie.title == "some updated title"
      assert movie.year == "some updated year"
    end

    test "update_movie/2 with invalid data returns error changeset" do
      movie = movie_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_movie(movie, @invalid_attrs)
      assert movie == Catalog.get_movie!(movie.id)
    end

    test "delete_movie/1 deletes the movie" do
      movie = movie_fixture()
      assert {:ok, %Movie{}} = Catalog.delete_movie(movie)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_movie!(movie.id) end
    end

    test "change_movie/1 returns a movie changeset" do
      movie = movie_fixture()
      assert %Ecto.Changeset{} = Catalog.change_movie(movie)
    end
  end
end
