defmodule SwaiWeb.SwarmLiveTest do
  use SwaiWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swai.SwarmsFixtures

  @create_attrs %{name: "some name", status: 42, description: "some description", edge_id: "some edge_id", user_id: "some user_id", biotope_id: "some biotope_id"}
  @update_attrs %{name: "some updated name", status: 43, description: "some updated description", edge_id: "some updated edge_id", user_id: "some updated user_id", biotope_id: "some updated biotope_id"}
  @invalid_attrs %{name: nil, status: nil, description: nil, edge_id: nil, user_id: nil, biotope_id: nil}

  defp create_swarm(_) do
    swarm = swarm_fixture()
    %{swarm: swarm}
  end

  describe "Index" do
    setup [:create_swarm]

    test "lists all swarms", %{conn: conn, swarm: swarm} do
      {:ok, _index_live, html} = live(conn, ~p"/swarms")

      assert html =~ "Listing Swarms"
      assert html =~ swarm.name
    end

    test "saves new swarm", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/swarms")

      assert index_live |> element("a", "New Swarm") |> render_click() =~
               "New Swarm"

      assert_patch(index_live, ~p"/swarms/new")

      assert index_live
             |> form("#swarm-form", swarm: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#swarm-form", swarm: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/swarms")

      html = render(index_live)
      assert html =~ "Swarm created successfully"
      assert html =~ "some name"
    end

    test "updates swarm in listing", %{conn: conn, swarm: swarm} do
      {:ok, index_live, _html} = live(conn, ~p"/swarms")

      assert index_live |> element("#swarms-#{swarm.id} a", "Edit") |> render_click() =~
               "Edit Swarm"

      assert_patch(index_live, ~p"/swarms/#{swarm}/edit")

      assert index_live
             |> form("#swarm-form", swarm: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#swarm-form", swarm: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/swarms")

      html = render(index_live)
      assert html =~ "Swarm updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes swarm in listing", %{conn: conn, swarm: swarm} do
      {:ok, index_live, _html} = live(conn, ~p"/swarms")

      assert index_live |> element("#swarms-#{swarm.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#swarms-#{swarm.id}")
    end
  end

  describe "Show" do
    setup [:create_swarm]

    test "displays swarm", %{conn: conn, swarm: swarm} do
      {:ok, _show_live, html} = live(conn, ~p"/swarms/#{swarm}")

      assert html =~ "Show Swarm"
      assert html =~ swarm.name
    end

    test "updates swarm within modal", %{conn: conn, swarm: swarm} do
      {:ok, show_live, _html} = live(conn, ~p"/swarms/#{swarm}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Swarm"

      assert_patch(show_live, ~p"/swarms/#{swarm}/show/edit")

      assert show_live
             |> form("#swarm-form", swarm: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#swarm-form", swarm: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/swarms/#{swarm}")

      html = render(show_live)
      assert html =~ "Swarm updated successfully"
      assert html =~ "some updated name"
    end
  end
end
