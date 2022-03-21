defmodule CrawlyCartoonMovie.Repo do
  use Ecto.Repo,
    otp_app: :crawly_cartoon_movie,
    adapter: Ecto.Adapters.Postgres
end
