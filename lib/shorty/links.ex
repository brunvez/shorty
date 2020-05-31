defmodule Shorty.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false
  alias Shorty.Repo

  alias Shorty.Links.ShortenedLink
  alias Shorty.Links.View, as: LinkView

  def list_shortened_links do
    Repo.all(ShortenedLink)
  end

  def get_shortened_link!(id), do: Repo.get!(ShortenedLink, id) |> Repo.preload(:views)

  def get_by_path!(path), do: ShortenedLink |> where(shortened_path: ^path) |> Repo.one!()

  def create_shortened_link(attrs \\ %{}) do
    %ShortenedLink{}
    |> ShortenedLink.changeset(attrs)
    |> Repo.insert()
  end

  def add_view(link, attrs \\ %{}) do
    %LinkView{}
      |> LinkView.changeset(attrs)
      |> Ecto.Changeset.put_assoc(:link, link)
      |> Repo.insert()
  end

  def update_shortened_link(%ShortenedLink{} = shortened_link, attrs) do
    shortened_link
    |> ShortenedLink.changeset(attrs)
    |> Repo.update()
  end

  def delete_shortened_link(%ShortenedLink{} = shortened_link) do
    Repo.delete(shortened_link)
  end

  def change_shortened_link(%ShortenedLink{} = shortened_link, attrs \\ %{}) do
    ShortenedLink.changeset(shortened_link, attrs)
  end
end
