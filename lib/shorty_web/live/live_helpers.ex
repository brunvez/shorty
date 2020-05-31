defmodule ShortyWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `ShortyWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, ShortyWeb.ShortenedLinkLive.FormComponent,
        id: @shortened_link.id || :new,
        action: @live_action,
        shortened_link: @shortened_link,
        return_to: Routes.shortened_link_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, ShortyWeb.ModalComponent, modal_opts)
  end
end
