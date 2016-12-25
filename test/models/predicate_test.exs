defmodule Comindivion.PredicateTest do
  use Comindivion.ModelCase

  alias Comindivion.Predicate

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Predicate.changeset(%Predicate{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Predicate.changeset(%Predicate{}, @invalid_attrs)
    refute changeset.valid?
  end
end
