defmodule Shorty.LinksTest do
  use Shorty.DataCase

  alias Shorty.Links

  describe "shortened_links" do
    alias Shorty.Links.ShortenedLink

    @valid_attrs %{
      name: "some link",
      original_url: "http://www.google.com",
      shortened_path: "some_shortened_path"
    }
    @update_attrs %{
      name: "New name",
      original_url: "http://www.google-updated.com",
      shortened_path: "a_new_path"
    }
    @invalid_attrs %{original_url: nil, shortened_path: nil}

    def shortened_link_fixture(attrs \\ %{}) do
      {:ok, shortened_link} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Links.create_shortened_link()

      shortened_link
    end

    test "list_shortened_links/0 returns all shortened_links" do
      shortened_link = shortened_link_fixture()
      assert Links.list_shortened_links() == [shortened_link]
    end

    test "get_shortened_link!/1 returns the shortened_link with given id" do
      shortened_link = shortened_link_fixture()
      link_id = shortened_link.id
      assert %ShortenedLink{id: ^link_id} = Links.get_shortened_link!(shortened_link.id)
    end

    test "create_shortened_link/1 with valid data creates a shortened_link" do
      assert {:ok, %ShortenedLink{} = shortened_link} = Links.create_shortened_link(@valid_attrs)
      assert shortened_link.original_url == "http://www.google.com"
      assert shortened_link.shortened_path == "some_shortened_path"
    end

    test "create_shortened_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_shortened_link(@invalid_attrs)
    end

    test "update_shortened_link/2 with valid data updates the shortened_link" do
      shortened_link = shortened_link_fixture()

      assert {:ok, %ShortenedLink{} = shortened_link} =
               Links.update_shortened_link(shortened_link, @update_attrs)

      assert shortened_link.original_url == "http://www.google-updated.com"
      assert shortened_link.shortened_path == "a_new_path"
    end

    test "update_shortened_link/2 with invalid data returns error changeset" do
      shortened_link = shortened_link_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Links.update_shortened_link(shortened_link, @invalid_attrs)

      link_id = shortened_link.id
      assert %ShortenedLink{id: ^link_id} = Links.get_shortened_link!(shortened_link.id)
    end

    test "delete_shortened_link/1 deletes the shortened_link" do
      shortened_link = shortened_link_fixture()
      assert {:ok, %ShortenedLink{}} = Links.delete_shortened_link(shortened_link)
      assert_raise Ecto.NoResultsError, fn -> Links.get_shortened_link!(shortened_link.id) end
    end

    test "change_shortened_link/1 returns a shortened_link changeset" do
      shortened_link = shortened_link_fixture()
      assert %Ecto.Changeset{} = Links.change_shortened_link(shortened_link)
    end
  end
end
