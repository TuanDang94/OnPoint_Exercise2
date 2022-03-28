defmodule CrawlyCartoonMovie.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movie" do
    field :full_series, :boolean
    field :link, :string
    field :num_of_episode, :string
    field :thumnail, :string
    field :title, :string
    field :year, :string
    field :director, :string
    field :nation, :string

    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [
      :title,
      :link,
      :full_series,
      :num_of_episode,
      :thumnail,
      :year,
      :director,
      :nation
    ])
    |> validate_required([:title, :link, :full_series, :num_of_episode, :thumnail, :year])
  end
end
