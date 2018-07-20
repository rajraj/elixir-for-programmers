defmodule GallowsWeb.HangmanController do
  use GallowsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, _params) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)

    conn
    |> put_session(:game, game)
    |> render("game.html", tally: tally)
  end

  def make_move(conn, params) do
    guess = params["make_move"]["guess"]

    tally =
      conn
      |> get_session(:game)
      |> Hangman.make_move(guess)

    put_in(conn.params["make_move"]["guess"], "")
    |> render("game.html", tally: tally)
  end
end
