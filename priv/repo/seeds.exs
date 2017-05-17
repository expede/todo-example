# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Todo.Repo.insert!(%Todo.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Todo.{Factory}

IO.puts "*** Seeding Users ***"

users =
  10..30
  |> Enum.random()
  |> Factory.insert_list(:user)

IO.puts "*** Seeding Lists ***"

lists =
  0..20
  |> Enum.random()
  |> Range.new(30)
  |> Enum.map(fn _ ->
    random_users = Enum.take_random(users, Enum.random(5..20))
    Factory.insert(:list, users: random_users)
  end)

IO.puts "*** Seeding Items ***"

0..300
|> Enum.random()
|> Range.new(400)
|> Enum.map(fn _ ->
  completer = if Enum.random([true, true, false]), do: Enum.random(users)
  Factory.insert(:item, list: Enum.random(lists), completer: completer)
end)
