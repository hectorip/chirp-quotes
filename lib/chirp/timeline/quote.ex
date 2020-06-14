defmodule Chirp.Timeline.Quote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quotes" do
    field :body, :string
    field :likes_count, :integer
    field :repost_count, :integer
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:username, :body, :likes_count, :repost_count])
    |> validate_required([:username, :body, :likes_count, :repost_count])
  end
end
