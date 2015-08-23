defmodule Apiv3.AppointmentMeta do
  alias Apiv3.Repo
  alias Apiv3.AppointmentQuery

  def generate(params, account) do
    %{
      total_pages: total_pages(params, account),
      count: count(params, account),
      current_page: current_page(params),
      per_page: per_page(params)
    }
  end

  def current_page(%{"page" => page}) when is_integer(page) do page end
  def current_page(%{"page" => page}) do
    {p, _} = Integer.parse(page)
    p
  end
  def current_page(_), do: 1

  def total_pages(params, account) do
    total_entries = count(params, account)
    entries_per_page = per_page params
    if rem(total_entries, entries_per_page) == 0 do
      div(total_entries, entries_per_page)
    else
      div(total_entries, entries_per_page) + 1
    end
  end

  def per_page(%{"per_page" => pp}) when is_integer(pp) do pp end
  def per_page(%{"per_page" => pp}) do
    {p, _} = Integer.parse(pp)
    p
  end
  def per_page(_), do: 10

  def count(params, account) do
    params |> AppointmentQuery.pagination(account) |> Repo.one
  end

end