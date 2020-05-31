defmodule ShortyWeb.ShortenedLinkLive.FormComponent do
  use ShortyWeb, :live_component

  alias Shorty.Links

  @impl true
  def update(%{shortened_link: shortened_link} = assigns, socket) do
    changeset = Links.change_shortened_link(shortened_link)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"shortened_link" => shortened_link_params}, socket) do
    changeset =
      socket.assigns.shortened_link
      |> Links.change_shortened_link(shortened_link_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"shortened_link" => shortened_link_params}, socket) do
    save_shortened_link(socket, socket.assigns.action, shortened_link_params)
  end

  defp save_shortened_link(socket, :edit, shortened_link_params) do
    case Links.update_shortened_link(socket.assigns.shortened_link, shortened_link_params) do
      {:ok, _shortened_link} ->
        {:noreply,
         socket
         |> put_flash(:info, "Shoretened link updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_shortened_link(socket, :new, shortened_link_params) do
    case Links.create_shortened_link(shortened_link_params) do
      {:ok, _shortened_link} ->
        {:noreply,
         socket
         |> put_flash(:info, "Shoretened link created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
