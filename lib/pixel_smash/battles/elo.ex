defmodule PixelSmash.Battles.ELO do
  @k_factor 24

  def expected_result(player, opponent) do
    1.0 / (1.0 + :math.pow(10.0, (opponent - player) / 400.0))
  end

  def new_score(player, opponent, result) do
    factor =
      case result do
        :win -> 1.0
        :draw -> 0.5
        :loss -> 0.0
      end

    expected = expected_result(player, opponent)
    delta = @k_factor * (factor - expected)

    round(player + delta)
  end
end
