defmodule ShortyWeb.ShortenedLinkLive.Index do
  use ShortyWeb, :live_view

  alias Shorty.Links
  alias Shorty.Links.ShortenedLink

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :shortened_links, list_shortened_links())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Shoretened link")
    |> assign(:shortened_link, Links.get_shortened_link!(id))
  end

  defp apply_action(socket, :new, _params) do
    random_string = :crypto.strong_rand_bytes(16) |> Base.encode64() |> binary_part(0, 16)

    socket
    |> assign(:page_title, "New Shoretened link")
    |> assign(:shortened_link, %ShortenedLink{shortened_path: random_string})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Shortened links")
    |> assign(:shortened_link, nil)
  end

  @impl true
  @spec handle_event(<<_::48>>, map, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_event("delete", %{"id" => id}, socket) do
    shortened_link = Links.get_shortened_link!(id)
    {:ok, _} = Links.delete_shortened_link(shortened_link)

    {:noreply, assign(socket, :shortened_links, list_shortened_links())}
  end

  defp list_shortened_links do
    Links.list_shortened_links()
  end
end
