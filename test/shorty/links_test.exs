defmodule Shorty.LinksTest do
  use Shorty.DataCase

  alias Shorty.Links

  describe "shortened_links" do
    alias Shorty.Links.ShortenedLink

    @valid_attrs %{metadata: %{}, original_url: "some original_url", shortened_path: "some shortened_path"}
    @update_attrs %{metadata: %{}, original_url: "some updated original_url", shortened_path: "some updated shortened_path"}
    @invalid_attrs %{metadata: nil, original_url: nil, shortened_path: nil}

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
      assert Links.get_shortened_link!(shortened_link.id) == shortened_link
    end

    test "create_shortened_link/1 with valid data creates a shortened_link" do
      assert {:ok, %ShortenedLink{} = shortened_link} = Links.create_shortened_link(@valid_attrs)
      assert shortened_link.metadata == %{}
      assert shortened_link.original_url == "some original_url"
      assert shortened_link.shortened_path == "some shortened_path"
    end

    test "create_shortened_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_shortened_link(@invalid_attrs)
    end

    test "update_shortened_link/2 with valid data updates the shortened_link" do
      shortened_link = shortened_link_fixture()
      assert {:ok, %ShortenedLink{} = shortened_link} = Links.update_shortened_link(shortened_link, @update_attrs)
      assert shortened_link.metadata == %{}
      assert shortened_link.original_url == "some updated original_url"
      assert shortened_link.shortened_path == "some updated shortened_path"
    end

    test "update_shortened_link/2 with invalid data returns error changeset" do
      shortened_link = shortened_link_fixture()
      assert {:error, %Ecto.Changeset{}} = Links.update_shortened_link(shortened_link, @invalid_attrs)
      assert shortened_link == Links.get_shortened_link!(shortened_link.id)
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
