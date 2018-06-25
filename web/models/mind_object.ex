defmodule Comindivion.MindObject do
  use Comindivion.Web, :model

  # :binary_id is managed by drivers/adapters, it will be UUID for mysql, postgres
  #  but can be ObjectID if later you decide to use mongo
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Poison.Encoder, only: [:id, :title, :content, :uri, :number, :date, :datetime]}
  schema "mind_objects" do
    field :title, :string
    field :content, :string
    field :uri, :string
    field :number, :decimal
    field :date, :date
    field :datetime, :utc_datetime
    field :data, :binary

    has_one :position, Comindivion.Position, on_replace: :update
    has_many :subject_relations, Comindivion.SubjectObjectRelation, foreign_key: :subject_id
    has_many :object_relations, Comindivion.SubjectObjectRelation, foreign_key: :object_id
    belongs_to :user, Comindivion.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content, :uri, :number, :date, :datetime, :data])
    |> cast_assoc(:position, required: false)
    |> validate_required([:title, :user_id])
    |> unique_constraint(:title)
  end
end
