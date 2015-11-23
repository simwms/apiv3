defmodule Apiv3.BroadcastUtils do
  alias Apiv3.Endpoint
  alias Fox.RecordExt

  @levels ~w(info success warning alert error)
  def notify(target, level, message) do
    topic = infer_topic(target)
    Endpoint.broadcast topic, "notify", %{level: level, message: message}
  end

  def delta(target, model) do
    view = RecordExt.view_for_model(model)
    delta(target, view, model)
  end

  def delta(target, view_class, model) do
    data = view_class.render("show.json", make_hash(model))
    topic = infer_topic(target)
    Endpoint.broadcast topic, "delta", data
  end

  def infer_topic(%Apiv3.User{id: id}) do
    "users:#{id}"
  end

  def infer_topic(%Apiv3.Account{id: id}) do
    "accounts:#{id}"
  end

  def make_hash(%Apiv3.User{}=u) do
    %{user: u}
  end

  def make_hash(%Apiv3.PaymentSubscription{}=ps) do
    %{payment_subscription: ps}
  end

end