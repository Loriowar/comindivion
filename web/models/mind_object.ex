defmodule Comindivion.MindObject do
  use Comindivion.Web, :model

  schema "mind_objects" do
    field :id, Ecto.UUID
    field :title, :string
    field :content, :string
    field :number, :decimal
    field :date, Ecto.Date
    field :datetime, Ecto.DateTime
    field :data, :binary

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :title, :content, :number, :date, :datetime, :data])
    |> validate_required([:id, :title, :content, :number, :date, :datetime, :data])
  end
end
