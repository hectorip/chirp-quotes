defmodule Chirp.Timeline.Quote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quotes" do
    field :body, :string
    field :likes_count, :integer, default: 0
    field :repost_count, :integer, default: 0
    field :username, :string, default: "hectorip"

    timestamps()
  end

  @doc false
  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> validate_length(:body, min: 2, max: 500)
  end
end
