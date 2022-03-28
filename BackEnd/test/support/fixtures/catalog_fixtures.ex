defmodule CrawlyCartoonMovie.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CrawlyCartoonMovie.Catalog` context.
  """

  @doc """
  Generate a movie.
  """
  def movie_fixture(attrs \\ %{}) do
    {:ok, movie} =
      attrs
      |> Enum.into(%{
        full_series: "some full_series",
        link: "some link",
        num_of_episode: "some num_of_episode",
        thumnail: "some thumnail",
        title: "some title",
        year: "some year"
      })
      |> CrawlyCartoonMovie.Catalog.create_movie()

    movie
  end
end
