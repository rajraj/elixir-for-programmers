defmodule Hangman.GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new returns structure" do
    game = Game.new()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "make_move does not change a won or lost game" do
    for state <- [:won, :lost] do
      game = Game.new() |> Map.put(:game_state, state)

      assert {^game, _tally} = Game.make_move(game, "a")
    end
  end

  test "first occurance of letter is not already used" do
    game = Game.new()
    {game, _tally} = Game.make_move(game, "a")

    assert game.game_state != :already_used
  end

  test "second occurance of letter is already used" do
    game = Game.new()
    {game, _tally} = Game.make_move(game, "a")

    assert game.game_state != :already_used

    {game, _tally} = Game.make_move(game, "a")

    assert game.game_state == :already_used
  end

  test "a good guess is recognised" do
    game = Game.new("wibble")
    {game, _tally} = Game.make_move(game, "w")

    assert game.game_state == :good_guess
  end

  test "a guessed word is a won game" do
    game = Game.new("wibble")

    {game, _tally} = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7

    {game, _tally} = Game.make_move(game, "i")
    assert game.game_state == :good_guess
    assert game.turns_left == 7

    {game, _tally} = Game.make_move(game, "b")
    assert game.game_state == :good_guess
    assert game.turns_left == 7

    {game, _tally} = Game.make_move(game, "l")
    assert game.game_state == :good_guess
    assert game.turns_left == 7

    {game, _tally} = Game.make_move(game, "e")
    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "a bad guess is recognised" do
    game = Game.new("wibble")
    {game, _tally} = Game.make_move(game, "x")

    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "all turns is a lost game" do
    game = Game.new("w")

    {game, _tally} = Game.make_move(game, "a")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6

    {game, _tally} = Game.make_move(game, "b")
    assert game.game_state == :bad_guess
    assert game.turns_left == 5

    {game, _tally} = Game.make_move(game, "c")
    assert game.game_state == :bad_guess
    assert game.turns_left == 4

    {game, _tally} = Game.make_move(game, "d")
    assert game.game_state == :bad_guess
    assert game.turns_left == 3

    {game, _tally} = Game.make_move(game, "e")
    assert game.game_state == :bad_guess
    assert game.turns_left == 2

    {game, _tally} = Game.make_move(game, "f")
    assert game.game_state == :bad_guess
    assert game.turns_left == 1

    {game, _tally} = Game.make_move(game, "g")
    assert game.game_state == :lost
  end
end
