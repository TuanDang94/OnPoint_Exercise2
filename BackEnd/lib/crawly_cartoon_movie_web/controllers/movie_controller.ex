defmodule CrawlyCartoonMovieWeb.MovieController do
  use CrawlyCartoonMovieWeb, :controller
  import Kernel, except: [inspect: 1]
  import CrawlyCartoonMovie.Crawler

  def getcategories(conn, %{"url" => url}) do
    data = http_poison_response_bycategories(url)
    conn |> json(data)
  end
end
