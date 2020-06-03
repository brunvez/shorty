defmodule Shorty.Links.View do
  use Ecto.Schema
  import Ecto.Changeset

  alias Shorty.Links.ShortenedLink

  schema "views" do
    field :city, :string
    field :country, :string
    field :ip, :string
    field :system_os, :string
    field :user_agent, :string
    belongs_to :link, ShortenedLink

    timestamps()
  end

  @doc false
  def changeset(view, attrs) do
    view
    |> cast(attrs, [:country, :city, :ip, :system_os, :link_id, :user_agent])
    |> validate_required([])
    |> assoc_constraint(:link)
  end
end
