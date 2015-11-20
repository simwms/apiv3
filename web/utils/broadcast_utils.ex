defmodule Apiv3.BroadcastUtils do
  alias Apiv3.Endpoint
  alias Fox.RecordExt

  def delta(user, model) do
    view = RecordExt.view_for_model(model)
    delta(user, view, model)
  end

  def delta(user, view_class, model) do
    data = view_class.render("show.json", make_hash(model))
    Endpoint.broadcast "users_socket:#{user.id}", "delta", data
  end

  def make_hash(%Apiv3.User{}=u) do
    %{user: u}
  end

  def make_hash(%Apiv3.PaymentSubscription{}=ps) do
    %{payment_subscription: ps}
  end

end