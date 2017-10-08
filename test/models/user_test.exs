defmodule Todo.UserTest do
  use Todo.ModelCase, async: true

  doctest Todo.Accounts.User

  test "User" do
    assert true
  end
end
