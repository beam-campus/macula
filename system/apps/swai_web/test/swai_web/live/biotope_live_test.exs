defmodule SwaiWeb.BiotopeLiveTest do
  use SwaiWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swai.BiotopesFixtures

  @create_attrs %{name: "some name", description: "some description", image_url: "some image_url", theme: "some theme", tags: "some tags"}
  @update_attrs %{name: "some updated name", description: "some updated description", image_url: "some updated image_url", theme: "some updated theme", tags: "some updated tags"}
  @invalid_attrs %{name: nil, description: nil, image_url: nil, theme: nil, tags: nil}

  defp create_biotope(_) do
    biotope = biotope_fixture()
    %{biotope: biotope}
  end

  describe "Index" do
    setup [:create_biotope]

    test "lists all biotopes", %{conn: conn, biotope: biotope} do
      {:ok, _index_live, html} = live(conn, ~p"/biotopes")

      assert html =~ "Listing Biotopes"
      assert html =~ biotope.name
    end

    test "saves new biotope", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/biotopes")

      assert index_live |> element("a", "New Biotope") |> render_click() =~
               "New Biotope"

      assert_patch(index_live, ~p"/biotopes/new")

      assert index_live
             |> form("#biotope-form", biotope: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#biotope-form", biotope: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/biotopes")

      html = render(index_live)
      assert html =~ "Biotope created successfully"
      assert html =~ "some name"
    end

    test "updates biotope in listing", %{conn: conn, biotope: biotope} do
      {:ok, index_live, _html} = live(conn, ~p"/biotopes")

      assert index_live |> element("#biotopes-#{biotope.id} a", "Edit") |> render_click() =~
               "Edit Biotope"

      assert_patch(index_live, ~p"/biotopes/#{biotope}/edit")

      assert index_live
             |> form("#biotope-form", biotope: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#biotope-form", biotope: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/biotopes")

      html = render(index_live)
      assert html =~ "Biotope updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes biotope in listing", %{conn: conn, biotope: biotope} do
      {:ok, index_live, _html} = live(conn, ~p"/biotopes")

      assert index_live |> element("#biotopes-#{biotope.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#biotopes-#{biotope.id}")
    end
  end

  describe "Show" do
    setup [:create_biotope]

    test "displays biotope", %{conn: conn, biotope: biotope} do
      {:ok, _show_live, html} = live(conn, ~p"/biotopes/#{biotope}")

      assert html =~ "Show Biotope"
      assert html =~ biotope.name
    end

    test "updates biotope within modal", %{conn: conn, biotope: biotope} do
      {:ok, show_live, _html} = live(conn, ~p"/biotopes/#{biotope}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Biotope"

      assert_patch(show_live, ~p"/biotopes/#{biotope}/show/edit")

      assert show_live
             |> form("#biotope-form", biotope: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#biotope-form", biotope: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/biotopes/#{biotope}")

      html = render(show_live)
      assert html =~ "Biotope updated successfully"
      assert html =~ "some updated name"
    end
  end
end
