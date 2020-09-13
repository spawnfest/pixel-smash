defmodule PixelSmash.Gladiators.ELO do
  @k_factor 24

  alias PixelSmash.Gladiators.Gladiator

  def expected_result(%Gladiator{} = player, %Gladiator{} = opponent) do
    1.0 / (1.0 + :math.pow(10.0, (opponent.elo - player.elo) / 400.0))
  end

  def handle_battle_result({%Gladiator{} = left, %Gladiator{} = right}, winner) do
    left_new_score =
      case winner do
        :left -> new_score(left, right, :win)
        :draw -> new_score(left, right, :draw)
        :right -> new_score(left, right, :loss)
      end

    right_new_score =
      case winner do
        :left -> new_score(right, left, :loss)
        :draw -> new_score(right, left, :draw)
        :right -> new_score(right, left, :win)
      end

    left = %Gladiator{left | elo: left_new_score}
    right = %Gladiator{right | elo: right_new_score}

    {left, right}
  end

  def new_score(%Gladiator{} = player, %Gladiator{} = opponent, result) do
    factor =
      case result do
        :win -> 1.0
        :draw -> 0.5
        :loss -> 0.0
      end

    expected = expected_result(player, opponent)
    delta = @k_factor * (factor - expected)

    round(player.elo + delta)
  end
end
