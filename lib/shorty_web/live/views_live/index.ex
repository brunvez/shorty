defmodule ShortyWeb.ViewsLive.Index do
  use ShortyWeb, :live_view

  alias Shorty.Links

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :views, Links.list_views())}
  end
end
