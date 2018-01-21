# defmodule VkConfSend.TgVk do
#   use Ecto.Schema
#
#   schema "users" do
#     field :chat, :integer
#     field :vk_token, :string
#   end
#
#   schema "chats" do
#     field :chat, :string
#     field :vk_token, :string
#   end
# end

defmodule VkConfSend.Repo.Migrations.CreateAll do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :chat, :integer, unique: true
      add :vk_token, :string
      timestamps
    end

    # Actually we should relate :users.id and :chats
    # But nobody cares
    # Also I don't know ecto syntax
    create table(:chats) do
      add :chat, :integer
      add :vk_chat_name, :string
      add :vk_token, :string
    end
  end
end
