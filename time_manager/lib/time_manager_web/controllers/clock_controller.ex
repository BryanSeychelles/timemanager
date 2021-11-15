defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Management
  alias TimeManager.Management.Clock

  action_fallback(TimeManagerWeb.FallbackController)

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    clocks = Management.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"user_id" => user_id}) do
    current_user = Guardian.Plug.current_resource(conn)

    params = Map.merge(%{"user_id" => user_id}, conn.body_params["clock"])

    with {:ok, %Clock{} = clock} <- Management.create_clock(params) do
      conn
      |> put_status(:created)
      |> render("show.json", clock: clock)
    end
  end

  def show(conn, %{"user_id" => user_id}) do
    current_user = Guardian.Plug.current_resource(conn)

    clock = Management.get_clock_by_user(user_id)
    render(conn, "show.json", clock: clock)
  end

  def update(conn, %{"user_id" => user_id, "clock" => clock_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    clock = Management.get_clock_by_user(user_id)

    IO.inspect(clock_params)

    with {:ok, %Clock{} = clock} <- Management.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"user_id" => user_id}) do
    current_user = Guardian.Plug.current_resource(conn)

    clock = Management.get_clock_by_user(user_id)

    with {:ok, %Clock{}} <- Management.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end

  def options(conn, _) do
    send_resp(conn, 200, "Access-Control-Allow-Origin: *")
  end
end
