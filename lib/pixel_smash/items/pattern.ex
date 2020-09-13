defmodule PixelSmash.Items.Pattern do
  alias PixelSmash.Items.Item

  def helmet() do
    %Item{
      x: 5,
      y: 4,
      data: [
        ["0", "X", "X", "X", "X"],
        ["X", "X", "X", "X", "t"],
        ["X", "t", " ", " ", " "]
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
        ["X", "z", "X", "z", "X"],
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
        ["0", "0", "0", "z", "X"],
        ["z", "0", "0", "X", "X"],
        ["z", "X", "X", "X", "X"],
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
        [" ", "X", "X", "X", "X"]
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
        [" ", "t", "X", "X", "t"],
        ["X", "X", "0", "0", "X"],
        ["X", "X", "0", "0", "X"],
        [" ", "t", "X", "X", "t"]
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
        ["X", "0", "0", "z", "0"],
        ["X", "0", "0", "z", "0"],
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
        [" ", " ", " ", " ", " "],
        [" ", "X", " ", " ", " "],
        [" ", "X", " ", " ", " "],
        [" ", "X", " ", " ", " "],
        [" ", "X", " ", " ", " "],
        [" ", "X", " ", " ", " "]
      ],
      type: :stick
    }
  end

  def sword() do
    %Item{
      x: 5,
      y: 6,
      data: [
        [" ", "t", " ", " ", " "],
        [" ", "X", " ", " ", " "],
        [" ", "X", " ", " ", " "],
        [" ", "X", " ", " ", " "],
        ["X", "X", "X", " ", " "],
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
        ["t", "X", "X", " ", " "],
        ["X", "X", "X", "X", " "],
        ["X", "X", "X", "X", " "],
        ["t", "X", "X", " ", " "]
      ],
      type: :glove
    }
  end
end
