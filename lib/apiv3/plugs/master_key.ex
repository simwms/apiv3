defmodule Apiv3.Plugs.MasterKey do
  import Plug.Conn
  import Phoenix.Controller, only: [render: 4]
  @master_key Application.get_env(:simwms, :master_key)

  def init(o), do: o

  def call(conn, _o) do
    case conn |> has_master_key? do
      {:error, msg} ->
        conn
        |> put_status(:forbidden)
        |> render(Apiv3.ErrorView, "forbidden.json", msg: msg)
        |> halt
        
      {:ok, _} -> conn
    end
  end

  defp has_master_key?(conn) do
    conn 
    |> get_req_header("simwms-master-key")
    |> List.first
    |> match_master_key?
  end

  def master_key do
    @master_key
  end

  defp match_master_key?(request_key) do
    case {request_key, master_key} do
      {nil, nil} -> {:error, "missing both server and request master key"}
      {nil,   _} -> {:error, "missing request master key"}
      {_,   nil} -> {:error, "missing server master key"}
      {key, key} -> {:ok, "match"}
      {key,   _} -> {:error, "request key doesn't match server key"}
    end
  end
end