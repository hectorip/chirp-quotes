defmodule Chirp.Repo.Migrations.CreateQuotes do
  use Ecto.Migration

  def change do
    create table(:quotes) do
      add :username, :string
      add :body, :string
      add :likes_count, :integer
      add :repost_count, :integer

      timestamps()
    end

  end
end
