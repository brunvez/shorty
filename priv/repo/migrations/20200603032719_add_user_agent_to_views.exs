defmodule Shorty.Repo.Migrations.AddUserAgentToViews do
  use Ecto.Migration

  def change do
    alter table("views") do
      add :user_agent, :string, default: ""
    end
  end
end
