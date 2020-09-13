defmodule PixelSmash.Items.Pattern do
  alias PixelSmash.Items.Item

  def helmet() do
    %Item{
      x: 5,
      y: 4,
      data: [
        ["0", "X", "X", "X", "X"],
        ["X", "X", "X", "X", "?"],
        ["X", "X", " ", " ", " "],
        ["X", "?", " ", " ", " "]
      ],
      type: :helmet
    }
  end

  def crown() do
    %Item{
      x: 5,
      y: 4,
      data: [
        ["X", "0", "X", "0", "X"],
        ["X", "0", "X", "0", "X"],
        ["X", "?", "X", "?", "X"],
        ["X", "X", "X", "X", "X"]
      ],
      type: :crown
    }
  end

  def hat() do
    %Item{
      x: 5,
      y: 4,
      data: [
        ["0", "0", "0", "?", "X"],
        ["?", "0", "0", "X", "X"],
        ["?", "X", "X", "X", "X"],
        ["X", "X", "X", "X", "X"]
      ],
      type: :hat
    }
  end

  def eyepatch() do
    %Item{
      x: 5,
      y: 4,
      data: [
        ["X", "X", "X", "X", " "],
        [" ", "X", "X", "X", " "],
        [" ", "X", "X", "X", " "],
        [" ", "X", "X", "X", " "]
      ],
      type: :eyepatch
    }
  end

  def scouter() do
    %Item{
      x: 5,
      y: 5,
      data: [
        ["X", "X", "X", "X", "X"],
        ["X", "X", "0", "0", "X"],
        ["X", "X", "0", "0", "X"],
        [" ", "X", "0", "0", "X"],
        [" ", "X", "X", "X", "X"]
      ],
      type: :scouter
    }
  end

  def googles() do
    %Item{
      x: 5,
      y: 4,
      data: [
        [" ", "?", "X", "X", "?"],
        ["X", "X", "0", "0", "X"],
        ["X", "X", "0", "0", "X"],
        [" ", "?", "X", "X", "?"]
      ],
      type: :googles
    }
  end

  def unilens() do
    %Item{
      x: 5,
      y: 4,
      data: [
        ["0", "X", "X", "X", "X"],
        ["X", " ", " ", "?", " "],
        ["X", " ", " ", "?", " "],
        ["0", "X", "X", "X", "X"]
      ],
      type: :unilens
    }
  end

  def stick() do
    %Item{
      x: 5,
      y: 6,
      data: [
        [" ", "?", " ", " ", " "],
        [" ", "X", " ", " ", " "],
        [" ", "X", " ", " ", " "],
        ["?", "X", "?", " ", " "],
        ["?", "X", "?", " ", " "],
        [" ", "X", " ", " ", " "]
      ],
      type: :stick
    }
  end

  def glove() do
    %Item{
      x: 5,
      y: 4,
      data: [
        ["?", "X", "?", " ", " "],
        ["X", "X", "X", " ", " "],
        ["X", "X", "X", " ", " "],
        ["?", "X", "?", " ", " "]
      ],
      type: :glove
    }
  end
end
