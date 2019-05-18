defmodule VacuumCleanerTest do
  use ExUnitProperties
  use ExUnit.Case
  doctest VacuumCleaner

  alias VacuumCleaner, as: VC

  def gen_direction do
    member_of([:east, :north, :west, :south])
  end

  def gen_vc(vc = %VC{} \\ %VC{}) do
    gen all x_ <- if(vc.x, do: constant(vc.x), else: one_of([constant(0), positive_integer()])),
            y_ <- if(vc.y, do: constant(vc.y), else: one_of([constant(0), positive_integer()])),
            direction_ <- if(vc.direction, do: constant(vc.direction), else: gen_direction()) do
      %VC{x: x_, y: y_, direction: direction_}
    end
  end

  def gen_room do
    gen all x <- positive_integer(),
            y <- positive_integer() do
      %Room{x: x, y: y}
    end
  end

  def gen_movable_room do
    gen all x <- positive_integer(),
            y <- positive_integer() do
      %Room{x: x + 1, y: y + 1}
    end
  end

  def gen_instructions do
    list_of(member_of([:left, :right, :move]))
  end

  def is_in_room(vc = %VC{}, room = %Room{}) do
    vc.x >= 0 && vc.y >= 0 && vc.x < room.x && vc.y < room.y
  end

  def furthest_available(room_length), do: max(room_length - 1, 0)
  def furthest_movable(room_length), do: max(room_length - 2, 0)

  describe "turn vacuum cleaner" do
    property "x and y stays the same after turn" do
      check all vc <- gen_vc(),
                direction <- member_of([:left, :right]) do
        next_vc = vc |> VC.turn(direction)

        assert next_vc.x == vc.x
        assert next_vc.y == vc.y
      end
    end

    property "turn same direction 4 times, vacuum cleaner gets back to where it started" do
      check all vc <- gen_vc(),
                direction <- member_of([:left, :right]) do
        next_vc =
          vc
          |> VC.turn(direction)
          |> VC.turn(direction)
          |> VC.turn(direction)
          |> VC.turn(direction)

        assert next_vc == vc
      end
    end

    property "turn left and then turn right should get back to where it starts" do
      check all vc <- gen_vc() do
        assert vc |> VC.turn(:left) |> VC.turn(:right) == vc
        assert vc |> VC.turn(:right) |> VC.turn(:left) == vc
      end
    end
  end

  describe "move and not hitting the wall" do
    property "add 1 to y when facing north" do
      check all room <- gen_movable_room(),
                x <- integer(0..(room.x |> furthest_available)),
                y <- integer(0..(room.y |> furthest_movable)),
                vc <- gen_vc(%VC{x: x, y: y, direction: :north}) do
        assert vc |> VC.move(room) == %VC{vc | y: vc.y + 1}
      end
    end

    property "deduct 1 from y when facing south" do
      check all room <- gen_movable_room(),
                x <- integer(0..(room.x |> furthest_available)),
                y <- integer(1..(room.y |> furthest_available)),
                vc <- gen_vc(%VC{x: x, y: y, direction: :south}) do
        assert vc |> VC.move(room) == %VC{vc | y: vc.y - 1}
      end
    end

    property "add 1 to x when facing east" do
      check all room <- gen_movable_room(),
                x <- integer(0..(room.x |> furthest_movable)),
                y <- integer(0..(room.y |> furthest_available)),
                vc <- gen_vc(%VC{x: x, y: y, direction: :east}) do
        assert vc |> VC.move(room) == %VC{vc | x: vc.x + 1}
      end
    end

    property "deduct 1 from x when facing west" do
      check all room <- gen_movable_room(),
                x <- integer(1..(room.x |> furthest_available)),
                y <- integer(0..(room.y |> furthest_available)),
                vc <- gen_vc(%VC{x: x, y: y, direction: :west}) do
        assert vc |> VC.move(room) == %VC{vc | x: vc.x - 1}
      end
    end
  end

  describe "move and hitting the wall" do
    property "do nothing when facing north and position is at the north boundary" do
      check all room <- gen_room(),
                x <- integer(0..(room.x |> furthest_available)),
                vc <- gen_vc(%VC{x: x, y: room.y, direction: :north}) do
        assert vc |> VC.move(room) == vc
      end
    end

    property "do nothing when facing east and position is at the east boundary" do
      check all room <- gen_room(),
                y <- integer(0..(room.y |> furthest_available)),
                vc <- gen_vc(%VC{x: room.x, y: y, direction: :east}) do
        assert vc |> VC.move(room) == vc
      end
    end

    property "do nothing when facing south and position is at the south boundary" do
      check all room <- gen_room(),
                x <- integer(0..(room.x |> furthest_available)),
                vc <- gen_vc(%VC{x: x, y: 0, direction: :south}) do
        assert vc |> VC.move(room) == vc
      end
    end

    property "do nothing when facing west and position is at the west boundary" do
      check all room <- gen_room(),
                y <- integer(0..(room.y |> furthest_available)),
                vc <- gen_vc(%VC{x: 0, y: y, direction: :west}) do
        assert vc |> VC.move(room) == vc
      end
    end
  end

  describe "execute list of instructions" do
    property "empty instruction should not make vacuum cleaner move" do
      check all room <- gen_room(),
                x <- integer(0..(room.x |> furthest_available)),
                y <- integer(0..(room.y |> furthest_available)),
                vc <- gen_vc(%VC{x: x, y: y}) do
        instructions = []
        assert instructions |> VC.execute(vc, room) == vc
      end
    end

    property "never leave the room if the initial position is in the room" do
      check all room <- gen_room(),
                x <- integer(0..(room.x |> furthest_available)),
                y <- integer(0..(room.y |> furthest_available)),
                vc <- gen_vc(%VC{x: x, y: y}),
                instructions <- gen_instructions(),
                result <- constant(instructions |> VC.execute(vc, room)) do
        assert result |> is_in_room(room) == true
      end
    end
  end
end
