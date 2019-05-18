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
    do: if(vc.y < room.y - 1, do: move(vc), else: vc)

  def move(vc = %VacuumCleaner{direction: :east}, room),
    do: if(vc.x < room.x - 1, do: move(vc), else: vc)

  def move(vc = %VacuumCleaner{direction: :south}, _room),
    do: if(vc.y > 0, do: move(vc), else: vc)

  def move(vc = %VacuumCleaner{direction: :west}, _room),
    do: if(vc.x > 0, do: move(vc), else: vc)

  @doc """
  Giving vacuum cleaner set of instructions, initial state and room to execute.

  ## Examples

      iex> room = %Room{x: 6, y: 6}
      iex> vc = %VacuumCleaner{x: 1, y: 2, direction: :north}
      iex> instructions = [:left, :move, :left, :move, :left, :move, :left, :move, :move]
      iex> instructions |> VacuumCleaner.execute(vc, room)
      %VacuumCleaner{x: 1, y: 3, direction: :north}

      iex> room = %Room{x: 6, y: 6}
      iex> vc = %VacuumCleaner{x: 3, y: 5, direction: :north}
      iex> instructions = [:move, :left, :move] # first move does not move because it hits the wall
      iex> instructions |> VacuumCleaner.execute(vc, room)
      %VacuumCleaner{x: 2, y: 5, direction: :west}
  """
  def execute(instructions, initial_state, room) do
    instructions
    |> Enum.reduce(
      initial_state,
      fn instruction, vc ->
        case instruction do
          :move -> vc |> move(room)
          direction -> vc |> turn(direction)
        end
      end
    )
  end
end
