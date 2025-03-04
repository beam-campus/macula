defmodule SwaiWeb.StationLiveTest do
  use SwaiWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swai.StationsFixtures

  @create_attrs %{name: "some name", add: "some add", description: "some description", user_id: "some user_id", location_id: "some location_id", gateway: "some gateway", nature: "some nature"}
  @update_attrs %{name: "some updated name", add: "some updated add", description: "some updated description", user_id: "some updated user_id", location_id: "some updated location_id", gateway: "some updated gateway", nature: "some updated nature"}
  @invalid_attrs %{name: nil, add: nil, description: nil, user_id: nil, location_id: nil, gateway: nil, nature: nil}

  defp create_station(_) do
    station = station_fixture()
    %{station: station}
  end

  describe "Index" do
    setup [:create_station]

    test "lists all stations", %{conn: conn, station: station} do
      {:ok, _index_live, html} = live(conn, ~p"/stations")

      assert html =~ "Listing Stations"
      assert html =~ station.name
    end

    test "saves new station", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/stations")

      assert index_live |> element("a", "New Station") |> render_click() =~
               "New Station"

      assert_patch(index_live, ~p"/stations/new")

      assert index_live
             |> form("#station-form", station: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#station-form", station: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/stations")

      html = render(index_live)
      assert html =~ "Station created successfully"
      assert html =~ "some name"
    end

    test "updates station in listing", %{conn: conn, station: station} do
      {:ok, index_live, _html} = live(conn, ~p"/stations")

      assert index_live |> element("#stations-#{station.id} a", "Edit") |> render_click() =~
               "Edit Station"

      assert_patch(index_live, ~p"/stations/#{station}/edit")

      assert index_live
             |> form("#station-form", station: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#station-form", station: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/stations")

      html = render(index_live)
      assert html =~ "Station updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes station in listing", %{conn: conn, station: station} do
      {:ok, index_live, _html} = live(conn, ~p"/stations")

      assert index_live |> element("#stations-#{station.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#stations-#{station.id}")
    end
  end

  describe "Show" do
    setup [:create_station]

    test "displays station", %{conn: conn, station: station} do
      {:ok, _show_live, html} = live(conn, ~p"/stations/#{station}")

      assert html =~ "Show Station"
      assert html =~ station.name
    end

    test "updates station within modal", %{conn: conn, station: station} do
      {:ok, show_live, _html} = live(conn, ~p"/stations/#{station}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Station"

      assert_patch(show_live, ~p"/stations/#{station}/show/edit")

      assert show_live
             |> form("#station-form", station: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#station-form", station: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/stations/#{station}")

      html = render(show_live)
      assert html =~ "Station updated successfully"
      assert html =~ "some updated name"
    end
  end
end
