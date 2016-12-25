defmodule Comindivion.SubjectObjectRelationTest do
  use Comindivion.ModelCase

  alias Comindivion.SubjectObjectRelation

  @valid_attrs %{id: "7488a646-e31f-11e4-aace-600308960662"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SubjectObjectRelation.changeset(%SubjectObjectRelation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SubjectObjectRelation.changeset(%SubjectObjectRelation{}, @invalid_attrs)
    refute changeset.valid?
  end
end
