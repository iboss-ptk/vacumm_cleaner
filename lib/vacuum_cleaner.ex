defmodule Room do
  defstruct [:x, :y]
end

defmodule VacuumCleaner do
  defstruct [:x, :y, :direction]

  @moduledoc """
  Documentation for VacuumCleaner.
  """

  defp right(:north), do: :east
  defp right(:east), do: :south
  defp right(:south), do: :west
  defp right(:west), do: :north

  defp left(:north), do: :west
  defp left(:west), do: :south
  defp left(:south), do: :east
  defp left(:east), do: :north

  @doc """
  Turn vacuum cleaner left and right.

  ## Examples

      iex> %VacuumCleaner{x: 0, y: 0, direction: :north} |> VacuumCleaner.turn(:left)
      %VacuumCleaner{x: 0, y: 0, direction: :west}

      iex> %VacuumCleaner{x: 0, y: 0, direction: :north} |> VacuumCleaner.turn(:right)
      %VacuumCleaner{x: 0, y: 0, direction: :east}

  """
  def turn(vc, :right), do: %VacuumCleaner{vc | direction: right(vc.direction)}
  def turn(vc, :left), do: %VacuumCleaner{vc | direction: left(vc.direction)}

  defp move(vc = %VacuumCleaner{direction: :north}), do: %VacuumCleaner{vc | y: vc.y + 1}
  defp move(vc = %VacuumCleaner{direction: :south}), do: %VacuumCleaner{vc | y: vc.y - 1}
  defp move(vc = %VacuumCleaner{direction: :east}), do: %VacuumCleaner{vc | x: vc.x + 1}
  defp move(vc = %VacuumCleaner{direction: :west}), do: %VacuumCleaner{vc | x: vc.x - 1}

  @doc """
  Move vacuum cleaner to their respective direction but not moving when hitting the wall.

  ## Examples

      iex> room = %Room{x: 10, y: 20}
      iex> %VacuumCleaner{x: 0, y: 0, direction: :north} |> VacuumCleaner.move(room)
      %VacuumCleaner{x: 0, y: 1, direction: :north}

      iex> room = %Room{x: 5, y: 7}
      iex> %VacuumCleaner{x: 5, y: 3, direction: :east} |> VacuumCleaner.move(room)
      %VacuumCleaner{x: 5, y: 3, direction: :east}
  """
  def move(vc = %VacuumCleaner{direction: :north}, room),
    do: if(vc.y < room.y, do: move(vc), else: vc)

  def move(vc = %VacuumCleaner{direction: :east}, room),
    do: if(vc.x < room.x, do: move(vc), else: vc)

  def move(vc = %VacuumCleaner{direction: :south}, _room),
    do: if(vc.y > 0, do: move(vc), else: vc)

  def move(vc = %VacuumCleaner{direction: :west}, _room),
    do: if(vc.x > 0, do: move(vc), else: vc)
end
