defmodule CrawlyCartoonMovie.Crawler do
  import Ecto.Query
  @url "https://ezphimmoi.net/category/hoat-hinh/"
  @naive_datetime NaiveDateTime.local_now()
  @max_page 1
  @page_size 20
  defp get_body_response(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        Floki.parse_document(body)

      _ ->
        {:error, nil}
    end
  end

  defp check_url_isblank(url) do
    url = String.trim(url)

    if url == "" do
      @url
    else
      url
    end
  end

  defp check_fielddata_empty(datafield) do
    if length(datafield) > 0 do
      hd(datafield)
    else
      ""
    end
  end

  defp convert_listdata_to_model(data) do
    data
    |> Enum.map(
      &%{
        title: check_fielddata_empty(&1["title"]),
        link: check_fielddata_empty(&1["link"]),
        num_of_episode: check_fielddata_empty(&1["num_of_episode"]),
        full_series: check_fielddata_empty(&1["full_series"]),
        thumnail: check_fielddata_empty(&1["thumnail"]),
        year: check_fielddata_empty(&1["year"]),
        director: check_fielddata_empty(&1["director"]),
        nation: check_fielddata_empty(&1["nation"]),
        inserted_at: @naive_datetime,
        updated_at: @naive_datetime
      }
    )
  end

  defp convert_mapdata_to_model(data) do
    data
    |> Enum.map(
      &%{
        title: check_fielddata_empty(&1[:title]),
        link: check_fielddata_empty(&1[:link]),
        num_of_episode: check_fielddata_empty(&1[:number_of_episode]),
        full_series: check_fielddata_empty(&1[:full_series]),
        thumnail: check_fielddata_empty(&1[:thumnail]),
        year: check_fielddata_empty(&1[:year]),
        director: check_fielddata_empty(&1[:director]),
        nation: check_fielddata_empty(&1[:nation]),
        inserted_at: @naive_datetime,
        updated_at: @naive_datetime
      }
    )
  end

  def import_datamovie(moviedata) do
    CrawlyCartoonMovie.Repo.insert_all(
      CrawlyCartoonMovie.Movie,
      convert_listdata_to_model(moviedata)
    )
  end

  def import_datamovie_fromlink(link) do
    data =
      craw_data(link)
      |> List.flatten()
      |> convert_mapdata_to_model

    CrawlyCartoonMovie.Repo.insert_all(CrawlyCartoonMovie.Movie, data)
  end

  defp craw_data(url) do
    url = check_url_isblank(url) |> String.replace("\\", "")

    for number_page <- 1..@max_page do
      url =
        if number_page == 1 do
          url
        else
          "#{url}page/#{Integer.to_string(number_page)}/"
        end

      http_poison_response_byurl(url)
    end
  end

  def http_poison_response_bycategories(url) do
    craw_data(url)
    |> List.flatten()
    |> convertdata()
  end

  defp convertdata(data_movies) do
    %{
      # crawled_at: DateTime.to_iso8601(DateTime.utc_now() |> DateTime.add(7 * 3600, :second)),
      totalcountmovie: get_movie_count_total(),
      total: Enum.count(data_movies),
      items: data_movies
    }
  end

  defp convertdata_forfilter(data_movies, totaldata) do
    %{
      # crawled_at: DateTime.to_iso8601(DateTime.utc_now() |> DateTime.add(7 * 3600, :second)),
      totalcountmovie: get_movie_count_total(),
      total: totaldata,
      items: data_movies
    }
  end

  defp get_direction_nation_bymovie(linkfilm) do
    with {:ok, document} <- get_body_response(linkfilm) do
      document
      |> Floki.find(
        ".block-movie-info .movie-dl"
        # ".container .row .block-wrapper .movie-info .block-movie-info .movie-detail .movie-dl"
      )
      |> Enum.map(fn data ->
        %{
          director:
            data
            |> Floki.find(".director")
            |> Floki.attribute("title"),
          nation:
            data
            |> Floki.find(".movie-dd")
            |> Floki.find("a")
            |> Floki.filter_out(".director")
            |> Floki.attribute("title")
        }
      end)
      |> hd()
    else
      :error -> {:error, []}
    end
  end

  defp mapdatamovie(data) do
    link_movie =
      data
      |> Floki.attribute("href")

    nation_director_movie = get_direction_nation_bymovie(link_movie)

    %{
      title:
        data
        |> Floki.attribute("title"),
      link: link_movie,
      full_series:
        data
        |> Floki.find("span.ribbon")
        |> Enum.map(&Floki.text/1)
        |> Enum.map(fn title ->
          if String.contains?(title, ["FULL", "Full"]) do
            true
          else
            false
          end
        end),
      num_of_episode:
        data
        |> Floki.find("span.ribbon")
        |> Enum.map(&Floki.text/1),
      thumnail:
        data
        |> Floki.find(".public-film-item-thumb")
        |> Floki.attribute("data-wpfc-original-src"),
      year:
        data
        |> Floki.find("span.movie-title-2")
        |> Enum.map(&Floki.text/1)
        |> Enum.map(fn title ->
          if String.contains?(title, ["(", ")"]) do
            String.slice(title, -5, 4)
          else
            "No year"
          end
        end),
      # nation_director_movie[:director],
      director: nation_director_movie[:director],
      # nation_director_movie[:nation]
      nation: nation_director_movie[:nation]
    }
  end

  defp http_poison_response_byurl(url) do
    with {:ok, document} <- get_body_response(check_url_isblank(url)) do
      document
      |> Floki.find(".movie-list-index .movie-item")
      |> Enum.map(fn data -> mapdatamovie(data) end)

      # |> convertdata()
    end
  end

  defp convert_structdata_to_map(data) do
    data
    |> Enum.map(fn item ->
      movie_item_data = Map.from_struct(item)

      %{
        title: List.insert_at([], 0, movie_item_data |> Map.get(:title)),
        link: List.insert_at([], 0, movie_item_data |> Map.get(:link)),
        num_of_episode: List.insert_at([], 0, movie_item_data |> Map.get(:num_of_episode)),
        full_series: List.insert_at([], 0, movie_item_data |> Map.get(:full_series)),
        thumnail: List.insert_at([], 0, movie_item_data |> Map.get(:thumnail)),
        year: List.insert_at([], 0, movie_item_data |> Map.get(:year)),
        director: List.insert_at([], 0, movie_item_data |> Map.get(:director)),
        nation: List.insert_at([], 0, movie_item_data |> Map.get(:nation))
      }
    end)
  end

  # def get_movie_from_database(page_number) do
  #   query =
  #     from u in CrawlyCartoonMovie.Movie,
  #       order_by: [asc: :id],
  #       select: [
  #         :id,
  #         :title,
  #         :link,
  #         :full_series,
  #         :num_of_episode,
  #         :thumnail,
  #         :year,
  #         :director,
  #         :nation
  #       ]

  #   CrawlyCartoonMovie.Repo.all(paginate(query, page_number, @page_size))
  #   |> convert_structdata_to_map()
  #   |> convertdata()
  # end
  def get_all(page_number) do
    query =
      from(u in CrawlyCartoonMovie.Movie,
        order_by: [asc: :id],
        select: [
          :id,
          :title,
          :link,
          :full_series,
          :num_of_episode,
          :thumnail,
          :year,
          :director,
          :nation
        ]
      )

    CrawlyCartoonMovie.Repo.all(paginate(query, page_number, @page_size))
    |> convert_structdata_to_map()
    |> convertdata()
  end

  def get_movie_from_database(page_number, filter_director, filter_nation) do
    filter_director = "%#{filter_director}%"
    filter_nation = "%#{filter_nation}%"

    query_count_data =
      from(u in CrawlyCartoonMovie.Movie,
        where: like(u.director, ^filter_director) and like(u.nation, ^filter_nation),
        select: count(u.link)
      )

    count_data = CrawlyCartoonMovie.Repo.all(query_count_data)
    IO.inspect("Count data here: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    IO.inspect(count_data)

    from(u in CrawlyCartoonMovie.Movie,
      order_by: [asc: :id],
      where: like(u.director, ^filter_director) and like(u.nation, ^filter_nation),
      select: [
        :id,
        :title,
        :link,
        :full_series,
        :num_of_episode,
        :thumnail,
        :year,
        :director,
        :nation
      ]
    )
    |> distinct(true)
    |> paginate(page_number, @page_size)
    |> CrawlyCartoonMovie.Repo.all()
    |> convert_structdata_to_map()
    |> convertdata_forfilter(count_data)

    # data =
    #   CrawlyCartoonMovie.Repo.all(paginate(query_get_data, page_number, @page_size))
    #   |> convert_structdata_to_map()

    # |> convertdata()

    # convertdata_forfilter(query_get_data, count_data)
  end

  defp paginate(query, page, size) do
    from(query,
      limit: ^size,
      offset: ^((page - 1) * size)
    )
  end

  def get_movie_count_total do
    CrawlyCartoonMovie.Repo.aggregate(CrawlyCartoonMovie.Movie, :count)
  end
end
