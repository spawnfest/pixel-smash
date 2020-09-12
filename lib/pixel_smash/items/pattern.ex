defmodule PixelSmash.Items.Pattern do
  defstruct [:data, :x, :y]

  def helmet() do
    %__MODULE__{
      x: 5,
      y: 4,
      data: [
        ["0", "X", "X", "X", "X"],
        ["X", "X", "X", "X", "?"],
        ["X", "X", " ", " ", " "],
        ["X", "?", " ", " ", " "]
      ]
    }
  end

  def crown() do
    %__MODULE__{
      x: 5,
      y: 4,
      data: [
        ["X", "0", "X", "0", "X"],
        ["X", "0", "X", "0", "X"],
        ["X", "?", "X", "?", "X"],
        ["X", "X", "X", "X", "X"]
      ]
    }
  end

  def hat() do
    %__MODULE__{
      x: 5,
      y: 4,
      data: [
        ["0", "0", "0", "?", "X"],
        ["?", "0", "0", "X", "X"],
        ["?", "X", "X", "X", "X"],
        ["X", "X", "X", "X", "X"]
      ]
    }
  end

  def googles() do
    %__MODULE__{
      x: 5,
      y: 4,
      data: [
        [" ", "?", "X", "?", " "],
        ["X", "X", "0", "X", "X"],
        ["X", "X", "0", "X", "X"],
        [" ", "?", "X", "?", " "]
      ]
    }
  end

  def unilens() do
    %__MODULE__{
      x: 5,
      y: 4,
      data: [
        ["0", "X", "X", "X", "X"],
        ["X", " ", " ", "?", " "],
        ["X", " ", " ", "?", " "],
        ["0", "X", "X", "X", "X"]
      ]
    }
  end

  def stick() do
    %__MODULE__{
      x: 5,
      y: 4,
      data: [
        [" ", "?", " "],
        [" ", "X", " "],
        [" ", "X", " "],
        ["?", "X", "?"],
        ["?", "X", "?"],
        [" ", "X", " "]
      ]
    }
  end

  def glove() do
    %__MODULE__{
      x: 5,
      y: 4,
      data: [
        ["?", "X", "X", "?"],
        ["X", "X", "X", "X"],
        ["X", "X", "X", "X"],
        ["?", "X", "X", "?"]
      ]
    }
  end
end
