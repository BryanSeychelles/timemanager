defmodule TimeManager.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table (:teams) do
      add :name, :string, null: false
      add :manager_id, :integer, null: false

      timestamps()
    end
  end
end
