defmodule VacuumCleanerTest do
  use ExUnitProperties
  use ExUnit.Case
  doctest VacuumCleaner

  alias VacuumCleaner, as: VC

  def gen_direction do
    member_of([:east, :north, :west, :south])
  end

  def gen_vc do
    gen all x <- integer(),
            y <- integer(),
            direction <- gen_direction() do
      %VC{x: x, y: y, direction: direction}
    end
  end

  describe "turn vacuum cleaner to the rigth" do
    property "x and y stays the same" do
      check all vc <- gen_vc() do
        next_vc = vc |> VC.turn(:right)

        assert next_vc.x == vc.x
        assert next_vc.y == vc.y
      end
    end

    property "turn right 4 times, vacuum cleaner gets back to where it started" do
      check all vc <- gen_vc() do
        next_vc =
          vc
          |> VC.turn(:right)
          |> VC.turn(:right)
          |> VC.turn(:right)
          |> VC.turn(:right)

        assert next_vc == vc
      end
    end
  end

  describe "turn vacuum cleaner to the left" do
    property "x and y stays the same" do
      check all vc <- gen_vc() do
        next_vc = vc |> VC.turn(:left)

        assert next_vc.x == vc.x
        assert next_vc.y == vc.y
      end
    end

    property "turn left 4 times, vacuum cleaner gets back to where it started" do
      check all vc <- gen_vc() do
        next_vc =
          vc
          |> VC.turn(:left)
          |> VC.turn(:left)
          |> VC.turn(:left)
          |> VC.turn(:left)

        assert next_vc == vc
      end
    end
  end

  describe "two vacuum cleaner starts from the same position" do
    property "each of them turn to different direction twice will results in the same position again" do
      check all vc <- gen_vc() do
        vc_left = vc |> VC.turn(:left) |> VC.turn(:left)
        vc_right = vc |> VC.turn(:right) |> VC.turn(:right)

        assert vc_left == vc_right
      end
    end
  end

  describe "turning left and right" do
    property "turn left and then turn right should get back to where it starts" do
      check all vc <- gen_vc() do
        assert vc |> VC.turn(:left) |> VC.turn(:right) == vc
        assert vc |> VC.turn(:right) |> VC.turn(:left) == vc
      end
    end
  end
end
