# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CrawlyCartoonMovie.Repo.insert!(%CrawlyCartoonMovie.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
CrawlyCartoonMovie.Repo.insert!(%CrawlyCartoonMovie.Movie{
  title: "Công Tố Viên Quân Sự Doberman - Military Prosecutor Doberman (2022)",
  link: "https://ezphimmoi.net/cong-to-vien-quan-su-doberman/",
  num_of_episode: "Tập 5 HD Vietsub",
  full_series: false,
  thumnail:
    "https://ezphimmoi.net/wp-content/uploads/2022/03/cong-to-vien-quan-su-doberman-62656-thumbnail-250x350.jpg",
  year: "2022"
})
