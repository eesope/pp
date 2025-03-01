defmodule Bcit.School.Student do
  use Ecto.Schema
  import Ecto.Changeset

  schema "students" do
    field :sid, :string
    field :firstname, :string
    field :lastname, :string
    field :score, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(student, attrs) do
    attrs = for {k, v} <- attrs, into: %{}, do: {k, String.trim(v)}
    student
    |> cast(attrs, [:sid, :firstname, :lastname, :score])
    |> validate_required([:sid, :firstname, :lastname, :score])
    |> validate_format(:sid, ~r/^a\d{8}$/)
    |> validate_number(:score, greater_than_or_equal_to: 0,
      less_than_or_equal_to: 100,
      message: "score must be between 0 and 100 inclusive")
    |> unique_constraint(:sid)
  end
end
