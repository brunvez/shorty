defmodule Shorty.Repo.Migrations.CreateShortenedLinks do
  use Ecto.Migration

  def change do
    create table(:shortened_links) do
      add :name, :string, null: false
      add :shortened_path, :string, null: false
      add :original_url, :string, null: false

      timestamps()
    end

    create unique_index(:shortened_links, [:name])
    create unique_index(:shortened_links, [:shortened_path])
  end
end
