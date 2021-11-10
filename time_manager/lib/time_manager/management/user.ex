defmodule TimeManager.Management.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt

  schema "users" do
    field :email, :string
    field :username, :string
    field :password_hash, :string
    field :role, Ecto.Enum, values: [Employee: 0, Manager: 1, General_Manager: 2]
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    many_to_many :teams, TimeManager.Management.Team, join_through: "users_teams"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :role])
    |> validate_required([:username, :email, :role])
  end

  def changeset_signup(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :role, :password, :password_confirmation])
    |> validate_required([:username, :email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}}
        ->
          put_change(changeset, :password_hash, hash_pwd_salt(pass))
      _ ->
          changeset
    end
  end
end
