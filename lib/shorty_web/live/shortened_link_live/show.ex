defmodule ShortyWeb.ShortenedLinkLive.Show do
  use ShortyWeb, :live_view

  alias Shorty.Links

  @link_views_topic "link_views"

  @impl true
  def mount(_params, _session, socket) do
    ShortyWeb.Endpoint.subscribe(@link_views_topic)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:shortened_link, Links.get_shortened_link!(id))}
  end

  @impl true
  def handle_info(%{topic: @link_views_topic, payload: %{link_id: link_id}}, socket) do
    if link_id == socket.assigns.shortened_link.id do
      {:noreply, assign(socket, :shortened_link, Links.get_shortened_link!(link_id))}
    else
      {:noreply, socket}
    end
  end

  defp page_title(:show), do: "Show Shoretened link"
  defp page_title(:edit), do: "Edit Shoretened link"
end
