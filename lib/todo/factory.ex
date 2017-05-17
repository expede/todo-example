defmodule Todo.Factory do
  @moduledoc "Factories for generating model data with `ExMachina`"

  use ExMachina.Ecto, repo: Todo.Repo

  # ===== #
  # Users #
  # ===== #

  @spec user_factory() :: Todo.User.t()
  def user_factory do
    %Todo.User{name: Faker.Name.En.name()}
  end

  # ===== #
  # Lists #
  # ===== #

  @spec list_factory() :: Todo.List.t()
  def list_factory do
    %Todo.List{name: Faker.Company.En.name()}
  end

  # ===== #
  # Items #
  # ===== #

  @spec item_factory() :: Todo.Item.t()
  def item_factory do
    name =
      if Enum.random([true, false]) do
        Faker.Beer.En.name()
      else
        Faker.Pokemon.En.name()
      end

    %Todo.Item{
      name: name,
      completer: build(:user),
      list: build(:list)
    }
  end
end
