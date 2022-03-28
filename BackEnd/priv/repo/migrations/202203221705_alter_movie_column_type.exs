defmodule CrawlyCartoonMovie.Repo.Migrations.CreateMovie do
  use Ecto.Migration

  def change do
    alter table(:movie) do
      modify :full_series, :boolean
    end
  end
end
