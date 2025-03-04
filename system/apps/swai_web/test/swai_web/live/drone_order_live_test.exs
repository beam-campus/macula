defmodule SwaiWeb.DroneOrderLiveTest do
  use SwaiWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swai.MarketplaceFixtures

  @create_attrs %{status: 42, description: "some description", currency: "some currency", quantity: 42, price_in_cents: 42}
  @update_attrs %{status: 43, description: "some updated description", currency: "some updated currency", quantity: 43, price_in_cents: 43}
  @invalid_attrs %{status: nil, description: nil, currency: nil, quantity: nil, price_in_cents: nil}

  defp create_drone_order(_) do
    drone_order = drone_order_fixture()
    %{drone_order: drone_order}
  end

  describe "Index" do
    setup [:create_drone_order]

    test "lists all drone_orders", %{conn: conn, drone_order: drone_order} do
      {:ok, _index_live, html} = live(conn, ~p"/drone_orders")

      assert html =~ "Listing Drone orders"
      assert html =~ drone_order.description
    end

    test "saves new drone_order", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/drone_orders")

      assert index_live |> element("a", "New Drone order") |> render_click() =~
               "New Drone order"

      assert_patch(index_live, ~p"/drone_orders/new")

      assert index_live
             |> form("#drone_order-form", drone_order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#drone_order-form", drone_order: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/drone_orders")

      html = render(index_live)
      assert html =~ "Drone order created successfully"
      assert html =~ "some description"
    end

    test "updates drone_order in listing", %{conn: conn, drone_order: drone_order} do
      {:ok, index_live, _html} = live(conn, ~p"/drone_orders")

      assert index_live |> element("#drone_orders-#{drone_order.id} a", "Edit") |> render_click() =~
               "Edit Drone order"

      assert_patch(index_live, ~p"/drone_orders/#{drone_order}/edit")

      assert index_live
             |> form("#drone_order-form", drone_order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#drone_order-form", drone_order: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/drone_orders")

      html = render(index_live)
      assert html =~ "Drone order updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes drone_order in listing", %{conn: conn, drone_order: drone_order} do
      {:ok, index_live, _html} = live(conn, ~p"/drone_orders")

      assert index_live |> element("#drone_orders-#{drone_order.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#drone_orders-#{drone_order.id}")
    end
  end

  describe "Show" do
    setup [:create_drone_order]

    test "displays drone_order", %{conn: conn, drone_order: drone_order} do
      {:ok, _show_live, html} = live(conn, ~p"/drone_orders/#{drone_order}")

      assert html =~ "Show Drone order"
      assert html =~ drone_order.description
    end

    test "updates drone_order within modal", %{conn: conn, drone_order: drone_order} do
      {:ok, show_live, _html} = live(conn, ~p"/drone_orders/#{drone_order}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Drone order"

      assert_patch(show_live, ~p"/drone_orders/#{drone_order}/show/edit")

      assert show_live
             |> form("#drone_order-form", drone_order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#drone_order-form", drone_order: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/drone_orders/#{drone_order}")

      html = render(show_live)
      assert html =~ "Drone order updated successfully"
      assert html =~ "some updated description"
    end
  end
end
