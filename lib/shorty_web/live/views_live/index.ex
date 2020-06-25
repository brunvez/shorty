defmodule ShortyWeb.ViewsLive.Index do
  use ShortyWeb, :live_view

  alias Shorty.Links

  @link_views_topic "link_views"

  @impl true
  def mount(_params, _session, socket) do
    ShortyWeb.Endpoint.subscribe(@link_views_topic)

    {:ok, assign(socket, :views, Links.list_views())}
  end

  @impl true
  def handle_info(%{topic: @link_views_topic, payload: _payload}, socket) do
    {:noreply, assign(socket, :views, Links.list_views())}
  end
end
