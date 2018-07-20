defmodule Comindivion.Position do
  use Comindivion.Web, :model

  # :binary_id is managed by drivers/adapters, it will be UUID for mysql, postgres
  #  but can be ObjectID if later you decide to use mongo
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Poison.Encoder, only: [:x, :y, :mind_object_id]}
  schema "positions" do
    field :x, :float
    field :y, :float
    field :group, :string

    belongs_to :mind_object, Comindivion.MindObject

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:x, :y])
    |> validate_required([:x, :y])
  end
end
