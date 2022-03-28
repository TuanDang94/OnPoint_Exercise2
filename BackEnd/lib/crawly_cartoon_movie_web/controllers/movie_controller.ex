defmodule CrawlyCartoonMovieWeb.MovieController do
  use CrawlyCartoonMovieWeb, :controller
  import Kernel, except: [inspect: 1]
  import CrawlyCartoonMovie.Crawler

  def getcategories(conn, %{"url" => url}) do
    data = http_poison_response_bycategories(url)
    conn |> json(data)
  end

  def importmovie(conn, params) do
    import_datamovie(params["_json"])
    text(conn, "Import data success")
  end

  def importbylink(conn, params) do
    import_datamovie_fromlink(params["link"])
    text(conn, "Import data success")
  end

  def getall(conn, _params) do
    data = get_all(1)
    conn |> json(data)
  end

  def getmoviebypageandfilter(conn, params) do
    data =
      get_movie_from_database(
        String.to_integer(params["pagenumber"]),
        params["director"],
        params["nation"]
      )

    conn |> json(data)
  end

  def gettotalcountmovie(conn, _params) do
    total = get_movie_count_total()
    conn |> json(total)
  end
end
