defmodule Apiv3.Plugs.ScrubParamsChoice do
  import Plug.Conn

  def init(required_keys\\["data"]) do
    {required_keys, Fox.EnumExt.oxford_join(required_keys, ", ", " or ")}
  end

  @spec call(Plug.Conn.t, {[String.t], String.t}) :: Plug.Conn.t
  def call(conn, {[], keys}) do
    raise Phoenix.MissingParamError, key: keys
  end
  def call(conn, {[required_key|remaining_keys], keys}) do
    try do
      conn |> Phoenix.Controller.scrub_params(required_key)
    rescue
      Phoenix.MissingParamError ->
        conn |> call({remaining_keys, keys})
    end
  end
end