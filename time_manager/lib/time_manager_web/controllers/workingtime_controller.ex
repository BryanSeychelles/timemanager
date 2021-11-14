defmodule TimeManagerWeb.WorkingtimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Management
  alias TimeManager.Management.Workingtime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    workingtimes = Management.list_workingtimes()
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"user_id" => user_id}) do
    params = Map.merge(%{"user_id" => user_id}, conn.body_params["workingtime"])
    with {:ok, %Workingtime{} = workingtime} <- Management.create_workingtime(params) do
      conn
      |> put_status(:created)
      |> render("show.json", workingtime: workingtime)
    end
  end

  def show(conn, %{"user_id" => user_id, "start" => start, "end" => ennd}) do
    workingtimes = Management.list_workingtimes_schedule(user_id, start, ennd)
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    workingtime = Management.list_workingtimes_by_user_and_id(user_id, id)
    render(conn, "show.json", workingtime: workingtime)
  end

  def show(conn, %{"user_id" => user_id}) do
    workingtimes = Management.list_workingtimes_by_user(user_id)
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def show_workingtimes_by_team(conn, %{"team_id" => team_id}) do
    workingtimes = Management.list_workingtimes_by_team(team_id)
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Management.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <- Management.update_workingtime(workingtime, workingtime_params) do
      render(conn, "show.json", workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Management.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Management.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end

  def options(conn, _, _) do
    send_resp(conn, 200, "Access-Control-Allow-Origin: *")
  end
end
