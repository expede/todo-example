defmodule Todo.Factory do
  @moduledoc "Factories for generating model data with `ExMachina`"

  use ExMachina.Ecto, repo: Todo.Repo

  # ===== #
  # Users #
  # ===== #

  @spec user_factory() :: Todo.User.t()
  def user_factory do
    %Todo.User{
      name: Faker.Name.En.name(),
      avatar_url: Enum.random([nil, Faker.Avatar.image_url()])
    }
  end

  # ===== #
  # Lists #
  # ===== #

  @spec list_factory() :: Todo.List.t()
  def list_factory do
    %Todo.List{
      name: Faker.Company.En.name(),
      notes: Enum.random([nil, Faker.Lorem.Shakespeare.En.hamlet()])
    }
  end

  # ===== #
  # Items #
  # ===== #

  @spec item_factory() :: Todo.Item.t()
  def item_factory do
    %Todo.Item{
      name: Enum.random([Faker.Beer.En.name(), Faker.Pokemon.En.name()]),
      image_url: Enum.random([nil, Faker.Internet.image_url()]),
      completer: build(:user),
      list: build(:list)
    }
  end
end
