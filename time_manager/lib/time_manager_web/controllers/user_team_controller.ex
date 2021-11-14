defmodule TimeManagerWeb.UserTeamController do
  use TimeManagerWeb, :controller

  alias TimeManager.Management
  alias TimeManager.Management.UserTeam
  alias TimeManagerWeb.Guardian

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    users_teams = Management.list_users_teams()
    render(conn, "index.json", users_teams: users_teams)
  end

  def create(conn, %{"user_team" => user_team_params}) do
    with {:ok, %UserTeam{} = user_team} <- Management.create_user_team(user_team_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user_team: user_team)
    end
  end

  def options(conn, _) do
    send_resp(conn, 200, "Access-Control-Allow-Origin: *")
  end
end
