defmodule ChirpWeb.QuoteLive.Index do
  use ChirpWeb, :live_view

  alias Chirp.Timeline
  alias Chirp.Timeline.Quote

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :quotes, list_quotes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Quote")
    |> assign(:quote, Timeline.get_quote!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Quote")
    |> assign(:quote, %Quote{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Quotes")
    |> assign(:quote, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    quote = Timeline.get_quote!(id)
    {:ok, _} = Timeline.delete_quote(quote)

    {:noreply, assign(socket, :quotes, list_quotes())}
  end

  defp list_quotes do
    Timeline.list_quotes()
  end
end
