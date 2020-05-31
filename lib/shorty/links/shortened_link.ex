defmodule Shorty.Links.ShortenedLink do
  use Ecto.Schema
  import Ecto.Changeset

  alias Shorty.Links.View

  schema "shortened_links" do
    field :name, :string
    field :original_url, :string
    field :shortened_path, :string
    has_many :views, View, foreign_key: :link_id

    timestamps()
  end

  @doc false
  def changeset(shoretened_link, attrs) do
    shoretened_link
    |> cast(attrs, [:name, :shortened_path, :original_url])
    |> validate_required([:name, :shortened_path, :original_url])
    |> unique_constraint(:name)
    |> unique_constraint(:shortened_path)
  end
end
