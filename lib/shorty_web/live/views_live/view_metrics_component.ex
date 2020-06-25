defmodule ShortyWeb.ShortenedLinkLive.ViewMetricsComponent do
  use ShortyWeb, :live_component

  def view_browser(view) do
    Browser.name(view.user_agent)
  end

  def unique_views(views) do
    views
    |> Enum.map(& &1.ip)
    |> Enum.uniq()
    |> Enum.count()
  end

  def views_by_place(views) do
    views
    |> Enum.map(&{&1.country, &1.city})
    |> Enum.frequencies()
    |> sort_by_counts()
    |> format()
  end

  def views_by_link(views) do
    views
    |> Enum.map(& &1.link.name)
    |> Enum.frequencies()
    |> sort_by_counts()
    |> format()
  end

  def sort_by_counts(enum_with_count) do
    enum_with_count
    |> Enum.sort_by(fn {_, count} -> count end, :desc)
  end

  defp format(data) do
    Enum.map(data, fn
      {{country, city}, views} -> [country, city, views]
      {label, views} -> [label, views]
    end)
  end
end
