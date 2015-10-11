defmodule Apiv3.UserHarmonizer do
  alias Apiv3.Repo
  alias Apiv3.User
  @moduledoc """
  Harmonizers are used in synchronize local database data with
  remote services, case in point: Stripe

  Outside of tests, one should use these things only in the context
  of warp jobs via the Apiv3.Stargate
  """
  def harmonize(user) do
    fn ->
      user |> synchronize_stripe
    end
  end

  def synchronize_stripe(user) do
    case user.stripe_customer_id do
      nil -> initialize_stripe(user)
      _ -> user
    end
  end

  defp initialize_stripe(user) do
    {:ok, customer} = create_stripe_customer user
    user
    |> User.changeset(%{"stripe_customer_id" => customer.id})
    |> Repo.update!
  end

  defp create_stripe_customer(user) do
    metadata = %{ "username" => user.username, "id" => user.id }
    Stripex.Customers.create email: user.email, metadata: metadata
  end
end