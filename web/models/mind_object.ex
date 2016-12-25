defmodule Comindivion.MindObject do
  use Comindivion.Web, :model

  # :binary_id is managed by drivers/adapters, it will be UUID for mysql, postgres
  #  but can be ObjectID if later you decide to use mongo
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "mind_objects" do
    field :title, :string
    field :content, :string
    field :uri, :string
    field :number, :decimal
    field :date, Ecto.Date
    field :datetime, Ecto.DateTime
    field :data, :binary

    has_many :predicates, Comindivion.Predicate
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
    |> cast(params, [:title, :content, :uri, :number, :date, :datetime, :data])
    |> validate_required([:title])
  end
end
