defmodule ShortyWeb.ShortenedLinkLiveTest do
  use ShortyWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Shorty.Links

  @create_attrs %{
    name: "New Link",
    original_url: "http://www.google.com",
    shortened_path: "some_shortened_path"
  }
  @create_new_attrs %{
    name: "Another New Link",
    original_url: "http://www.google.com",
    shortened_path: "another_shortened_path"
  }
  @update_attrs %{
    name: "New name",
    original_url: "http://www.google-updated.com",
    shortened_path: "a_new_path"
  }
  @invalid_attrs %{name: nil, original_url: nil, shortened_path: nil}

  defp fixture(:shortened_link) do
    {:ok, shortened_link} = Links.create_shortened_link(@create_attrs)
    shortened_link
  end

  defp create_shortened_link(_) do
    shortened_link = fixture(:shortened_link)
    %{shortened_link: shortened_link}
  end

  describe "Index" do
    setup [:create_shortened_link]

    test "lists all shortened_links", %{conn: conn, shortened_link: shortened_link} do
      {:ok, _index_live, html} = live(conn, Routes.shortened_link_index_path(conn, :index))

      assert html =~ "Listing Shortened links"
      assert html =~ shortened_link.original_url
    end

    test "saves new shortened_link", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.shortened_link_index_path(conn, :index))

      assert index_live |> element("a", "New Shoretened link") |> render_click() =~
               "New Shoretened link"

      assert_patch(index_live, Routes.shortened_link_index_path(conn, :new))

      assert index_live
             |> form("#shortened_link-form", shortened_link: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#shortened_link-form", shortened_link: @create_new_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.shortened_link_index_path(conn, :index))

      assert html =~ "Shoretened link created successfully"
      assert html =~ "http://www.google.com"
    end

    test "updates shortened_link in listing", %{conn: conn, shortened_link: shortened_link} do
      {:ok, index_live, _html} = live(conn, Routes.shortened_link_index_path(conn, :index))

      assert index_live
             |> element("#shortened_link-#{shortened_link.id} a", "Edit")
             |> render_click() =~
               "Edit Shoretened link"

      assert_patch(index_live, Routes.shortened_link_index_path(conn, :edit, shortened_link))

      assert index_live
             |> form("#shortened_link-form", shortened_link: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#shortened_link-form", shortened_link: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.shortened_link_index_path(conn, :index))

      assert html =~ "Shoretened link updated successfully"
      assert html =~ "http://www.google-updated.com"
    end

    test "deletes shortened_link in listing", %{conn: conn, shortened_link: shortened_link} do
      {:ok, index_live, _html} = live(conn, Routes.shortened_link_index_path(conn, :index))

      assert index_live
             |> element("#shortened_link-#{shortened_link.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#shortened_link-#{shortened_link.id}")
    end
  end

  describe "Show" do
    setup [:create_shortened_link]

    test "displays shortened_link", %{conn: conn, shortened_link: shortened_link} do
      {:ok, _show_live, html} =
        live(conn, Routes.shortened_link_show_path(conn, :show, shortened_link))

      assert html =~ "Show Shoretened link"
      assert html =~ shortened_link.original_url
    end

    test "updates shortened_link within modal", %{conn: conn, shortened_link: shortened_link} do
      {:ok, show_live, _html} =
        live(conn, Routes.shortened_link_show_path(conn, :show, shortened_link))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Shoretened link"

      assert_patch(show_live, Routes.shortened_link_show_path(conn, :edit, shortened_link))

      assert show_live
             |> form("#shortened_link-form", shortened_link: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#shortened_link-form", shortened_link: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.shortened_link_show_path(conn, :show, shortened_link))

      assert html =~ "Shoretened link updated successfully"
      assert html =~ "http://www.google-updated.com"
    end
  end
end
