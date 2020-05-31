defmodule Shorty.Repo.Migrations.CreateViews do
  use Ecto.Migration

  def change do
    create table(:views) do
      add :country, :string
      add :city, :string
      add :ip, :string
      add :system_os, :string
      add :link_id, references(:shortened_links, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:views, [:link_id])
  end
end
