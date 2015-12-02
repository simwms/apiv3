defmodule Apiv3.AccountDetailView do
  use Apiv3.Web, :view

  def render("show.json", %{account_detail: detail}) do
    %{ data: render_one(detail, __MODULE__, "account_detail.json") }
  end

  def render("account_detail.json", %{account_detail: detail}) do
    %{
      id: detail.id,
      type: "account_details",
      attributes: %{
        employees: detail.employees,
        docks: detail.docks,
        warehouses: detail.warehouses,
        scales: detail.scales,
      },
      relationships: %{
        account: %{
          data: %{
            id: detail.account_id, 
            type: "accounts"
          }
        },
        service_plan: %{
          data: %{
            id: detail.service_plan_id, 
            type: "service_plans"
          }
        },
        payment_subscription: %{
          data: %{
            id: detail.payment_subscription_id, 
            type: "payment_subscriptions"
          }
        },
        employee: %{ 
          data: %{ 
            id: detail.employee.id,
            type: "employees"
          }
        }
      }
    }
  end

end
