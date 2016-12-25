defmodule Comindivion.MindObjectTest do
  use Comindivion.ModelCase

  alias Comindivion.MindObject

  @valid_attrs %{content: "some content",
                 data: "some content",
                 date: %{day: 17,
                         month: 4,
                         year: 2010},
                 datetime: %{day: 17,
                             hour: 14,
                             min: 0,
                             month: 4,
                             sec: 0,
                             year: 2010},
                 number: "120.5",
                 title: "some content",
                 uri: "protocol://some.example.com/"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = MindObject.changeset(%MindObject{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = MindObject.changeset(%MindObject{}, @invalid_attrs)
    refute changeset.valid?
  end
end
