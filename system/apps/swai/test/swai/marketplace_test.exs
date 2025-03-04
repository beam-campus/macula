defmodule Swai.MarketplaceTest do
  use Swai.DataCase

  alias Swai.Marketplace

  describe "drone_orders" do
    alias Schema.DroneOrder

    import Swai.MarketplaceFixtures

    @invalid_attrs %{status: nil, description: nil, currency: nil, user_id: nil, quantity: nil, price_in_cents: nil}

    test "list_drone_orders/0 returns all drone_orders" do
      drone_order = drone_order_fixture()
      assert Marketplace.list_drone_orders() == [drone_order]
    end

    test "get_drone_order!/1 returns the drone_order with given id" do
      drone_order = drone_order_fixture()
      assert Marketplace.get_drone_order!(drone_order.id) == drone_order
    end

    test "create_drone_order/1 with valid data creates a drone_order" do
      valid_attrs = %{status: 42, description: "some description", currency: "some currency", user_id: "some user_id", quantity: 42, price_in_cents: 42}

      assert {:ok, %DroneOrder{} = drone_order} = Marketplace.create_drone_order(valid_attrs)
      assert drone_order.status == 42
      assert drone_order.description == "some description"
      assert drone_order.currency == "some currency"
      assert drone_order.user_id == "some user_id"
      assert drone_order.quantity == 42
      assert drone_order.price_in_cents == 42
    end

    test "create_drone_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Marketplace.create_drone_order(@invalid_attrs)
    end

    test "update_drone_order/2 with valid data updates the drone_order" do
      drone_order = drone_order_fixture()
      update_attrs = %{status: 43, description: "some updated description", currency: "some updated currency", user_id: "some updated user_id", quantity: 43, price_in_cents: 43}

      assert {:ok, %DroneOrder{} = drone_order} = Marketplace.update_drone_order(drone_order, update_attrs)
      assert drone_order.status == 43
      assert drone_order.description == "some updated description"
      assert drone_order.currency == "some updated currency"
      assert drone_order.user_id == "some updated user_id"
      assert drone_order.quantity == 43
      assert drone_order.price_in_cents == 43
    end

    test "update_drone_order/2 with invalid data returns error changeset" do
      drone_order = drone_order_fixture()
      assert {:error, %Ecto.Changeset{}} = Marketplace.update_drone_order(drone_order, @invalid_attrs)
      assert drone_order == Marketplace.get_drone_order!(drone_order.id)
    end

    test "delete_drone_order/1 deletes the drone_order" do
      drone_order = drone_order_fixture()
      assert {:ok, %DroneOrder{}} = Marketplace.delete_drone_order(drone_order)
      assert_raise Ecto.NoResultsError, fn -> Marketplace.get_drone_order!(drone_order.id) end
    end

    test "change_drone_order/1 returns a drone_order changeset" do
      drone_order = drone_order_fixture()
      assert %Ecto.Changeset{} = Marketplace.change_drone_order(drone_order)
    end
  end

  describe "drone_orders" do
    alias Schema.DroneOrder

    import Swai.MarketplaceFixtures

    @invalid_attrs %{status: nil, description: nil, currency: nil, quantity: nil, price_in_cents: nil}

    test "list_drone_orders/0 returns all drone_orders" do
      drone_order = drone_order_fixture()
      assert Marketplace.list_drone_orders() == [drone_order]
    end

    test "get_drone_order!/1 returns the drone_order with given id" do
      drone_order = drone_order_fixture()
      assert Marketplace.get_drone_order!(drone_order.id) == drone_order
    end

    test "create_drone_order/1 with valid data creates a drone_order" do
      valid_attrs = %{status: 42, description: "some description", currency: "some currency", quantity: 42, price_in_cents: 42}

      assert {:ok, %DroneOrder{} = drone_order} = Marketplace.create_drone_order(valid_attrs)
      assert drone_order.status == 42
      assert drone_order.description == "some description"
      assert drone_order.currency == "some currency"
      assert drone_order.quantity == 42
      assert drone_order.price_in_cents == 42
    end

    test "create_drone_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Marketplace.create_drone_order(@invalid_attrs)
    end

    test "update_drone_order/2 with valid data updates the drone_order" do
      drone_order = drone_order_fixture()
      update_attrs = %{status: 43, description: "some updated description", currency: "some updated currency", quantity: 43, price_in_cents: 43}

      assert {:ok, %DroneOrder{} = drone_order} = Marketplace.update_drone_order(drone_order, update_attrs)
      assert drone_order.status == 43
      assert drone_order.description == "some updated description"
      assert drone_order.currency == "some updated currency"
      assert drone_order.quantity == 43
      assert drone_order.price_in_cents == 43
    end

    test "update_drone_order/2 with invalid data returns error changeset" do
      drone_order = drone_order_fixture()
      assert {:error, %Ecto.Changeset{}} = Marketplace.update_drone_order(drone_order, @invalid_attrs)
      assert drone_order == Marketplace.get_drone_order!(drone_order.id)
    end

    test "delete_drone_order/1 deletes the drone_order" do
      drone_order = drone_order_fixture()
      assert {:ok, %DroneOrder{}} = Marketplace.delete_drone_order(drone_order)
      assert_raise Ecto.NoResultsError, fn -> Marketplace.get_drone_order!(drone_order.id) end
    end

    test "change_drone_order/1 returns a drone_order changeset" do
      drone_order = drone_order_fixture()
      assert %Ecto.Changeset{} = Marketplace.change_drone_order(drone_order)
    end
  end
end
