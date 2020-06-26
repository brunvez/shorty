defmodule ShortyWeb.RedirectionController do
  use ShortyWeb, :controller
  alias Shorty.Links

  @link_views_topic "link_views"

  def show(conn, %{"path" => path}) do
    link = Links.get_by_path!(path)

    Task.start(fn ->
      geo_data =
        case GeoIP.lookup(conn) do
          {:ok, data} -> data
          _ -> %{}
        end

      user_agent = conn |> get_req_header("user-agent") |> Enum.at(0, "")

      attrs = %{
        country: geo_data[:country_name],
        city: geo_data[:city],
        ip: geo_data[:ip],
        user_agent: user_agent
      }

      Links.add_view(link, attrs)

      ShortyWeb.Endpoint.broadcast(@link_views_topic, "new_view", %{link_id: link.id})
    end)

    redirect(conn, external: link.original_url)
  end
end
