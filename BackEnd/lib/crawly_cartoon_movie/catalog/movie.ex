defmodule CrawlyCartoonMovie.Catalog.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movie" do
    field :full_series, :string
    field :link, :string
    field :num_of_episode, :string
    field :thumnail, :string
    field :title, :string
    field :year, :string

    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:title, :link, :full_series, :num_of_episode, :thumnail, :year])
    |> validate_required([:title, :link, :full_series, :num_of_episode, :thumnail, :year])
  end
end
