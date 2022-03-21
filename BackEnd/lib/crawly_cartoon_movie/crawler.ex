defmodule CrawlyCartoonMovie.Crawler do
  @url "https://ezphimmoi.net/category/hoat-hinh/"
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

  def http_poison_response_bycategories(url) do
    url = check_url_isblank(url) |> String.replace("\\", "")

    for number_page <- 1..10 do
      url =
        if number_page == 1 do
          url
        else
          # url <>
          #   "page/" <>
          #   Integer.to_string(number_page) <> "/"
          "#{url}page/#{Integer.to_string(number_page)}/"
        end

      http_poison_response_byurl(url)
    end
  end

  def convertdata(data_movies) do
    %{
      # crawled_at: DateTime.to_iso8601(DateTime.utc_now() |> DateTime.add(7 * 3600, :second)),
      # total: Enum.count(data_movies),
      items: data_movies
    }
  end

  def http_poison_response_byurl(url) do
    with {:ok, document} <- get_body_response(check_url_isblank(url)) do
      document
      |> Floki.find(".movie-list-index .movie-item")
      |> Enum.map(fn data ->
        %{
          title:
            data
            |> Floki.attribute("title")
            |> Enum.map(&Floki.text/1),
          link:
            data
            |> Floki.attribute("href")
            |> Enum.map(&Floki.text/1),
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
          number_of_episode:
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
                # {:error, "No year"}
                "No year"
              end
            end)
        }
      end)
      |> convertdata()
    end
  end
end
