defmodule SwaiWeb.SwarmLicenseLiveTest do
  use SwaiWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swai.WorkspaceFixtures

  @create_attrs %{status: 42, swarm_size: 42, nbr_of_generations: 42, drone_depth: 42, generation_epoch_in_minutes: 42, select_best_count: 42, cost_in_tokens: 42, tokens_used: 42, total_run_time_in_seconds: 42, budget_in_tokens: 42}
  @update_attrs %{status: 43, swarm_size: 43, nbr_of_generations: 43, drone_depth: 43, generation_epoch_in_minutes: 43, select_best_count: 43, cost_in_tokens: 43, tokens_used: 43, total_run_time_in_seconds: 43, budget_in_tokens: 43}
  @invalid_attrs %{status: nil, swarm_size: nil, nbr_of_generations: nil, drone_depth: nil, generation_epoch_in_minutes: nil, select_best_count: nil, cost_in_tokens: nil, tokens_used: nil, total_run_time_in_seconds: nil, budget_in_tokens: nil}

  defp create_swarm_license(_) do
    swarm_license = swarm_license_fixture()
    %{swarm_license: swarm_license}
  end

  describe "Index" do
    setup [:create_swarm_license]

    test "lists all swarm_licenses", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/swarm_licenses")

      assert html =~ "Listing Swarm trainings"
    end

    test "saves new swarm_license", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/swarm_licenses")

      assert index_live |> element("a", "New Swarm training") |> render_click() =~
               "New Swarm training"

      assert_patch(index_live, ~p"/swarm_licenses/new")

      assert index_live
             |> form("#swarm_license-form", swarm_license: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#swarm_license-form", swarm_license: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/swarm_licenses")

      html = render(index_live)
      assert html =~ "Swarm training created successfully"
    end

    test "updates swarm_license in listing", %{conn: conn, swarm_license: swarm_license} do
      {:ok, index_live, _html} = live(conn, ~p"/swarm_licenses")

      assert index_live |> element("#swarm_licenses-#{swarm_license.id} a", "Edit") |> render_click() =~
               "Edit Swarm training"

      assert_patch(index_live, ~p"/swarm_licenses/#{swarm_license}/edit")

      assert index_live
             |> form("#swarm_license-form", swarm_license: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#swarm_license-form", swarm_license: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/swarm_licenses")

      html = render(index_live)
      assert html =~ "Swarm training updated successfully"
    end

    test "deletes swarm_license in listing", %{conn: conn, swarm_license: swarm_license} do
      {:ok, index_live, _html} = live(conn, ~p"/swarm_licenses")

      assert index_live |> element("#swarm_licenses-#{swarm_license.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#swarm_licenses-#{swarm_license.id}")
    end
  end

  describe "Show" do
    setup [:create_swarm_license]

    test "displays swarm_license", %{conn: conn, swarm_license: swarm_license} do
      {:ok, _show_live, html} = live(conn, ~p"/swarm_licenses/#{swarm_license}")

      assert html =~ "Show Swarm training"
    end

    test "updates swarm_license within modal", %{conn: conn, swarm_license: swarm_license} do
      {:ok, show_live, _html} = live(conn, ~p"/swarm_licenses/#{swarm_license}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Swarm training"

      assert_patch(show_live, ~p"/swarm_licenses/#{swarm_license}/show/edit")

      assert show_live
             |> form("#swarm_license-form", swarm_license: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#swarm_license-form", swarm_license: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/swarm_licenses/#{swarm_license}")

      html = render(show_live)
      assert html =~ "Swarm training updated successfully"
    end
  end
end
