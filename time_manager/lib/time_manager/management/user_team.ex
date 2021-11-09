defmodule TimeManager.Management.UserTeam do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_teams" do
    belongs_to :user, TimeManager.Management.User
    belongs_to :team, TimeManager.Management.Team
    timestamps()
  end

  @doc false
  def changeset(user_team, attrs) do
    user_team
    |> cast(attrs, [])
    |> validate_required([])
  end
end
