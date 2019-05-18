defmodule VacuumCleaner do
  defstruct [:x, :y, :direction]

  @moduledoc """
  Documentation for VacuumCleaner.
  """

  def right(:north), do: :east
  def right(:east), do: :south
  def right(:south), do: :west
  def right(:west), do: :north

  def left(:north), do: :west
  def left(:west), do: :south
  def left(:south), do: :east
  def left(:east), do: :north

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
end
