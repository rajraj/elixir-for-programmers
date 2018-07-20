defmodule GallowsWeb.HangmanView do
  use GallowsWeb, :view

  import GallowsWeb.Views.Helpers.GameStateHelper

  def game_over?(game_state) do
    game_state in [:won, :lost]
  end

  def new_game_button(conn) do
    button("New Game", to: hangman_path(conn, :create))
  end

  def word_so_far(letters) do
    letters
    |> Enum.join(" ")
  end

  def turn(left, target) when target >= left do
    "opacity: 1"
  end

  def turn(_left, _target) do
    "opacity: 0.1"
  end
end
