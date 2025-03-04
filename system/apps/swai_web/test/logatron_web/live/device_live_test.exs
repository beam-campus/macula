defmodule SwaiWeb.DeviceLiveTest do
  use SwaiWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swai.DevicesFixtures

  @create_attrs %{cpu: "some cpu", name: "some name", os_version: "some os_version", runtime: "some runtime", add: "some add", description: "some description", user_id: "some user_id", brand: "some brand", model: "some model", arcitecture: "some arcitecture", clock_mhz: "some clock_mhz", cores: 42, ram_gb: 42, storage_gb: 42, network: "some network", mac_address: "some mac_address", root_os: "some root_os", runtime_version: "some runtime_version"}
  @update_attrs %{cpu: "some updated cpu", name: "some updated name", os_version: "some updated os_version", runtime: "some updated runtime", add: "some updated add", description: "some updated description", user_id: "some updated user_id", brand: "some updated brand", model: "some updated model", arcitecture: "some updated arcitecture", clock_mhz: "some updated clock_mhz", cores: 43, ram_gb: 43, storage_gb: 43, network: "some updated network", mac_address: "some updated mac_address", root_os: "some updated root_os", runtime_version: "some updated runtime_version"}
  @invalid_attrs %{cpu: nil, name: nil, os_version: nil, runtime: nil, add: nil, description: nil, user_id: nil, brand: nil, model: nil, arcitecture: nil, clock_mhz: nil, cores: nil, ram_gb: nil, storage_gb: nil, network: nil, mac_address: nil, root_os: nil, runtime_version: nil}

  defp create_device(_) do
    device = device_fixture()
    %{device: device}
  end

  describe "Index" do
    setup [:create_device]

    test "lists all devices", %{conn: conn, device: device} do
      {:ok, _index_live, html} = live(conn, ~p"/devices")

      assert html =~ "Listing Devices"
      assert html =~ device.cpu
    end

    test "saves new device", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/devices")

      assert index_live |> element("a", "New Device") |> render_click() =~
               "New Device"

      assert_patch(index_live, ~p"/devices/new")

      assert index_live
             |> form("#device-form", device: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#device-form", device: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/devices")

      html = render(index_live)
      assert html =~ "Device created successfully"
      assert html =~ "some cpu"
    end

    test "updates device in listing", %{conn: conn, device: device} do
      {:ok, index_live, _html} = live(conn, ~p"/devices")

      assert index_live |> element("#devices-#{device.id} a", "Edit") |> render_click() =~
               "Edit Device"

      assert_patch(index_live, ~p"/devices/#{device}/edit")

      assert index_live
             |> form("#device-form", device: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#device-form", device: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/devices")

      html = render(index_live)
      assert html =~ "Device updated successfully"
      assert html =~ "some updated cpu"
    end

    test "deletes device in listing", %{conn: conn, device: device} do
      {:ok, index_live, _html} = live(conn, ~p"/devices")

      assert index_live |> element("#devices-#{device.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#devices-#{device.id}")
    end
  end

  describe "Show" do
    setup [:create_device]

    test "displays device", %{conn: conn, device: device} do
      {:ok, _show_live, html} = live(conn, ~p"/devices/#{device}")

      assert html =~ "Show Device"
      assert html =~ device.cpu
    end

    test "updates device within modal", %{conn: conn, device: device} do
      {:ok, show_live, _html} = live(conn, ~p"/devices/#{device}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Device"

      assert_patch(show_live, ~p"/devices/#{device}/show/edit")

      assert show_live
             |> form("#device-form", device: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#device-form", device: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/devices/#{device}")

      html = render(show_live)
      assert html =~ "Device updated successfully"
      assert html =~ "some updated cpu"
    end
  end
end
