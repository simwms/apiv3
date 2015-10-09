defmodule Apiv3.AccountDetailView do
  use Apiv3.Web, :view

  def render("show.json", %{account_detail: detail}) do
    %{account_detail: render_one(detail, __MODULE__, "account_detail.json")}
  end

  def render("account_detail.json", %{account_detail: detail}), do: detail

end
