defmodule ShortyWeb.ShortenedLinkLive.Show do
  use ShortyWeb, :live_view

  alias Shorty.Links

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:shortened_link, Links.get_shortened_link!(id))}
  end

  defp page_title(:show), do: "Show Shoretened link"
  defp page_title(:edit), do: "Edit Shoretened link"
end
