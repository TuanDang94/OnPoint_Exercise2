defmodule CrawlyCartoonMovie.Repo.Migrations.CreateMovie do
  use Ecto.Migration

  def change do
    alter table(:movie) do
      add :director, :string
      add :nation, :string
    end
  end
end
