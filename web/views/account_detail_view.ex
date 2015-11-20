defmodule Apiv3.AccountDetailView do
  use Apiv3.Web, :view

  def render("show.json", %{account_detail: detail}) do
    %{ account_detail: render_one(detail, __MODULE__, "account_detail.json") }
  end

  def render("account_detail.json", %{account_detail: detail}) do
    %{
      id: detail.id,
      account_id: detail.account_id,
      service_plan_id: detail.service_plan_id,
      payment_subscription_id: detail.payment_subscription_id,
      employees: detail.employees,
      docks: detail.docks,
      warehouses: detail.warehouses,
      scales: detail.scales,
      employee_id: detail.employee.id
    }
  end

end
