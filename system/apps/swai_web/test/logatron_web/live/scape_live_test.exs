defmodule SwaiWeb.ScapeLiveTest do
  use SwaiWeb.ConnCase

  import Phoenix.LiveViewTest
  import Service.ScapesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_scape(_) do
    scape = scape_fixture()
    %{scape: scape}
  end

  describe "Index" do
    setup [:create_scape]

    test "lists all scapes", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/scapes")

      assert html =~ "Listing Scapes"
    end

    test "saves new scape", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/scapes")

      assert index_live |> element("a", "New Scape") |> render_click() =~
               "New Scape"

      assert_patch(index_live, ~p"/scapes/new")

      assert index_live
             |> form("#scape-form", scape: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#scape-form", scape: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/scapes")

      html = render(index_live)
      assert html =~ "Scape created successfully"
    end

    test "updates scape in listing", %{conn: conn, scape: scape} do
      {:ok, index_live, _html} = live(conn, ~p"/scapes")

      assert index_live |> element("#scapes-#{scape.id} a", "Edit") |> render_click() =~
               "Edit Scape"

      assert_patch(index_live, ~p"/scapes/#{scape}/edit")

      assert index_live
             |> form("#scape-form", scape: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#scape-form", scape: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/scapes")

      html = render(index_live)
      assert html =~ "Scape updated successfully"
    end

    test "deletes scape in listing", %{conn: conn, scape: scape} do
      {:ok, index_live, _html} = live(conn, ~p"/scapes")

      assert index_live |> element("#scapes-#{scape.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#scapes-#{scape.id}")
    end
  end

  describe "Show" do
    setup [:create_scape]

    test "displays scape", %{conn: conn, scape: scape} do
      {:ok, _show_live, html} = live(conn, ~p"/scapes/#{scape}")

      assert html =~ "Show Scape"
    end

    test "updates scape within modal", %{conn: conn, scape: scape} do
      {:ok, show_live, _html} = live(conn, ~p"/scapes/#{scape}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Scape"

      assert_patch(show_live, ~p"/scapes/#{scape}/show/edit")

      assert show_live
             |> form("#scape-form", scape: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#scape-form", scape: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/scapes/#{scape}")

      html = render(show_live)
      assert html =~ "Scape updated successfully"
    end
  end
end
