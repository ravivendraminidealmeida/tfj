defmodule Tfj.Jobs.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jobs" do
    field :title, :string
    field :description, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(job, attrs, user_scope) do
    job
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
    |> put_change(:user_id, user_scope.user.id)
  end
end
