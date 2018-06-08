defmodule Comindivion.Predicate do
  use Comindivion.Web, :model

  # :binary_id is managed by drivers/adapters, it will be UUID for mysql, postgres
  #  but can be ObjectID if later you decide to use mongo
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "predicates" do
    field :name, :string

    has_many :subject_object_relations, Comindivion.SubjectObjectRelation
    has_many :subjects, through: [:subject_object_relations, :subject]
    has_many :objects, through: [:subject_object_relations, :object]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
