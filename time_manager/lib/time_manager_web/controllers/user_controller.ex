defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Management
  alias TimeManager.Management.User
  alias TimeManagerWeb.Guardian

  action_fallback(TimeManagerWeb.FallbackController)

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    users = Management.list_users()
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"email" => email, "username" => username}) do
    current_user = Guardian.Plug.current_resource(conn)

    user = Management.get_user_by!(email, username)
    render(conn, "show.json", user: user)
  end

  def show(conn, %{"userID" => id}) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user.role != 2 do
      {:error, :unauthorized}
    end

    user = Management.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def show_users_of_team(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)

    users = Management.list_users_by_team(id)
    render(conn, "index.json", users: users)
  end

  def show_employees(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    users = Management.list_employees()
    render(conn, "index.json", users: users)
  end

  def show(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    conn |> render("user.json", user: current_user)
  end

  def create(conn, %{"user" => user_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    with {:ok, %User{} = user} <- Management.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Management.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn |> render("jwt.json", jwt: token)

      _ ->
        {:error, :unauthorized}
    end
  end

  def update(conn, %{"userID" => id, "user" => user_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user.role != 2 && current_user.id != id do
      {:error, :unauthorized}
    end

    user = Management.get_user!(id)

    with {:ok, %User{} = user} <- Management.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"userID" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    user = Management.get_user!(id)

    with {:ok, %User{}} <- Management.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def options(conn, _) do
    send_resp(conn, 200, "Access-Control-Allow-Origin: *")
  end

  def promote(conn, %{"userID" => id, "user" => user_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    user = Management.get_user!(id)

    with {:ok, %User{} = user} <- Management.promote(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end
end
