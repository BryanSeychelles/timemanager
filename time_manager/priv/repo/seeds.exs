# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimeManager.Repo.insert!(%TimeManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

TimeManager.Repo.insert!(%TimeManager.Management.User{
  username: "admin",
  email: "admin@gmail.com",
  password_hash: "admin",
  role: :General_Manager
})
