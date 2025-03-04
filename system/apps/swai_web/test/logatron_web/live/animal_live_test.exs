defmodule SwaiWeb.AnimalLiveTest do
  use SwaiWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swai.Born2DiedsFixtures

  @create_attrs %{id: "some id", name: "some name", status: "some status", y: 42, x: 42, z: 42, edge_id: "some edge_id", scape_id: "some scape_id", region_id: "some region_id", farm_id: "some farm_id", field_id: "some field_id", life_id: "some life_id", gender: "some gender", father_id: "some father_id", mother_id: "some mother_id", birth_date: "2024-04-07", age: 42, weight: 42, energy: 42, is_pregnant: true, heath: 42, health: 42}
  @update_attrs %{id: "some updated id", name: "some updated name", status: "some updated status", y: 43, x: 43, z: 43, edge_id: "some updated edge_id", scape_id: "some updated scape_id", region_id: "some updated region_id", farm_id: "some updated farm_id", field_id: "some updated field_id", life_id: "some updated life_id", gender: "some updated gender", father_id: "some updated father_id", mother_id: "some updated mother_id", birth_date: "2024-04-08", age: 43, weight: 43, energy: 43, is_pregnant: false, heath: 43, health: 43}
  @invalid_attrs %{id: nil, name: nil, status: nil, y: nil, x: nil, z: nil, edge_id: nil, scape_id: nil, region_id: nil, farm_id: nil, field_id: nil, life_id: nil, gender: nil, father_id: nil, mother_id: nil, birth_date: nil, age: nil, weight: nil, energy: nil, is_pregnant: false, heath: nil, health: nil}

  defp create_animal(_) do
    animal = animal_fixture()
    %{animal: animal}
  end

  describe "Index" do
    setup [:create_animal]

    test "lists all born_2_dieds", %{conn: conn, animal: animal} do
      {:ok, _index_live, html} = live(conn, ~p"/born_2_dieds")

      assert html =~ "Listing Born 2 dieds"
      assert html =~ animal.id
    end

    test "saves new animal", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/born_2_dieds")

      assert index_live |> element("a", "New Animal") |> render_click() =~
               "New Animal"

      assert_patch(index_live, ~p"/born_2_dieds/new")

      assert index_live
             |> form("#animal-form", animal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#animal-form", animal: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/born_2_dieds")

      html = render(index_live)
      assert html =~ "Animal created successfully"
      assert html =~ "some id"
    end

    test "updates animal in listing", %{conn: conn, animal: animal} do
      {:ok, index_live, _html} = live(conn, ~p"/born_2_dieds")

      assert index_live |> element("#born_2_dieds-#{animal.id} a", "Edit") |> render_click() =~
               "Edit Animal"

      assert_patch(index_live, ~p"/born_2_dieds/#{animal}/edit")

      assert index_live
             |> form("#animal-form", animal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#animal-form", animal: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/born_2_dieds")

      html = render(index_live)
      assert html =~ "Animal updated successfully"
      assert html =~ "some updated id"
    end

    test "deletes animal in listing", %{conn: conn, animal: animal} do
      {:ok, index_live, _html} = live(conn, ~p"/born_2_dieds")

      assert index_live |> element("#born_2_dieds-#{animal.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#born_2_dieds-#{animal.id}")
    end
  end

  describe "Show" do
    setup [:create_animal]

    test "displays animal", %{conn: conn, animal: animal} do
      {:ok, _show_live, html} = live(conn, ~p"/born_2_dieds/#{animal}")

      assert html =~ "Show Animal"
      assert html =~ animal.id
    end

    test "updates animal within modal", %{conn: conn, animal: animal} do
      {:ok, show_live, _html} = live(conn, ~p"/born_2_dieds/#{animal}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Animal"

      assert_patch(show_live, ~p"/born_2_dieds/#{animal}/show/edit")

      assert show_live
             |> form("#animal-form", animal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#animal-form", animal: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/born_2_dieds/#{animal}")

      html = render(show_live)
      assert html =~ "Animal updated successfully"
      assert html =~ "some updated id"
    end
  end
end
