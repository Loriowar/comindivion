defmodule Comindivion.History do
  use Comindivion.Web, :model

  # :binary_id is managed by drivers/adapters, it will be UUID for mysql, postgres
  #  but can be ObjectID if later you decide to use mongo
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "history" do
    field :diff, :map

    has_many :further_history, Comindivion.History, foreign_key: :previous_history_id
    belongs_to :user, Comindivion.User
    belongs_to :previous_history, Comindivion.History

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:diff])
    |> validate_required([:diff, :user_id])
  end
end
