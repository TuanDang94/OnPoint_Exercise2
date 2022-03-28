defmodule CrawlyCartoonMovie.Repo.Migrations.CreateMovie do
  use Ecto.Migration

  def change do
    create table(:movie) do
      add :title, :string
      add :link, :string
      add :full_series, :boolean
      add :num_of_episode, :string
      add :thumnail, :string
      add :year, :string

      timestamps()
    end
  end
end
