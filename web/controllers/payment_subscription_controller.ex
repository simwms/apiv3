defmodule Apiv3.PaymentSubscriptionController do
  use Apiv3.Web, :controller
  alias Apiv3.PaymentSubscription
  alias Apiv3.PaymentSubscriptionHarmonizer, as: H

  plug Apiv3.Plugs.ScrubParamsChoice, ["data", "payment_subscription"] when action in [:update]

  def show(conn, _) do
    subscription = conn 
    |> get_subscription!
    |> Repo.preload([:service_plan, account: :user])
    |> synchronize_stripe!
    render(conn, "show.json", payment_subscription: subscription)
  end

  def update(conn, %{"payment_subscription" => params}) do
    subscription = conn |> get_subscription!
    params = params |> Dict.put("token_already_consumed", false)
    changeset = PaymentSubscription.changeset(subscription, params)

    if changeset.valid? do
      subscription = changeset
      |> Repo.update!
      |> Repo.preload([:service_plan, account: :user])
      |> synchronize_stripe!
      render(conn, "show.json", payment_subscription: subscription)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Apiv3.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def synchronize_stripe!(subscription) do
    subscription
    |> H.harmonize
    |> Apiv3.Stargate.warp_sync
    subscription
  end

  defp get_subscription!(conn) do
    conn
    |> current_account
    |> assoc(:payment_subscription)
    |> Repo.one!
  end
end