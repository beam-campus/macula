defmodule FlagsTest do
  use ExUnit.Case

  alias Flags

  defmodule TestFlags do
    def unknown, do: 0
    def initialized, do: 1
    def started, do: 2
    def stopped, do: 4
    def paused, do: 8
    def killed, do: 16

    def map,
      do: %{
        unknown() => "unknown",
        initialized() => "initialized",
        started() => "started",
        stopped() => "stopped",
        paused() => "paused",
        killed() => "killed"
      }
  end

  test "that we can set a flag using bor/2" do
    # GIVEN
    status =
      TestFlags.unknown()
      |> Flags.set(TestFlags.initialized())

    is_initialized =
      status
      |> Flags.has(TestFlags.initialized())

    assert is_initialized

    # WHEN
    new_status =
      status
      |> Flags.set(TestFlags.started())

    IO.puts("new status after Flags.set: #{new_status}")

    has_init =
      new_status
      |> Flags.has(TestFlags.initialized())

    has_started =
      new_status
      |> Flags.has(TestFlags.started())

    assert has_started and has_init
    # AND
    with_stopped =
      new_status
      |> Flags.unset(TestFlags.started())
      |> Flags.set(TestFlags.stopped())

    assert with_stopped
           |> Flags.has_not(TestFlags.started())

    with_killed =
      new_status
      |> Flags.set(TestFlags.killed())

    assert with_killed
           |> Flags.has(TestFlags.killed())

    IO.puts("with_killed has a value of #{inspect(with_killed)}")

    # THEN
  end

  @tag :ignore_test
  test "that we can set a flag using set/2" do
    # GIVEN
    status =
      TestFlags.unknown()
      |> Flags.set(TestFlags.initialized())

    is_initialized =
      status
      |> Flags.has(TestFlags.initialized())

    assert is_initialized

    # WHEN
    new_status =
      status
      |> Flags.set(TestFlags.started())

    IO.puts("new status after Flags.set: #{new_status}")

    has_init =
      new_status
      |> Flags.has(TestFlags.initialized())

    has_started =
      new_status
      |> Flags.has(TestFlags.started())

    assert has_started and has_init
    # AND
    with_stopped =
      new_status
      |> Flags.unset(TestFlags.started())
      |> Flags.set(TestFlags.stopped())

    assert with_stopped
           |> Flags.has_not(TestFlags.started())

    with_killed =
      new_status
      |> Flags.set(TestFlags.killed())

    assert with_killed |> Flags.has(TestFlags.killed())

    IO.puts("with_killed has a value of #{inspect(with_killed)}")

    # THEN
  end
end
