defmodule ChirpWeb.QuoteLive.QuoteComponent do
  use ChirpWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="quote-<%= @quote.id %>" class="quote">
      <b><%= @quote.username %></b>
      <p class="text-muted">
        <%= @quote.body %>
      </p>
      <%= live_patch to: Routes.quote_index_path(@socket, :edit, @quote.id), replace: false do %>
        Editar
      <% end %>
    </div>
    """
  end
end
