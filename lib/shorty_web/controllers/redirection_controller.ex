defmodule ShortyWeb.RedirectionController do
  use ShortyWeb, :controller
  alias Shorty.Links

  def show(conn, %{"path" => path}) do
    link = Links.get_by_path!(path)

    Task.start(fn ->
      geo_data =
        case GeoIP.lookup(conn) do
          {:ok, data} -> data
          _ -> %{}
        end
      attrs = %{country: geo_data[:country_name], city: geo_data[:city], ip: geo_data[:ip]}
      Links.add_view(link, attrs)
    end)

    redirect(conn, external: link.original_url)
  end
end
