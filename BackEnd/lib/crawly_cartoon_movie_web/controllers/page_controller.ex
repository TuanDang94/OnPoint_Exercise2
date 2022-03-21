defmodule CrawlyCartoonMovieWeb.PageController do
  use CrawlyCartoonMovieWeb, :controller
  import Kernel, except: [inspect: 1]
  import IO

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
