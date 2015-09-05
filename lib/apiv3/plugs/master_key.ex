defmodule Apiv3.Plugs.MasterKey do
  import Plug.Conn
  import Phoenix.Controller, only: [render: 4]
  @master_key Application.get_env(:simwms, :master_key)

  def init(o), do: o

  def call(conn, _o) do
    case conn |> has_master_key? do
      true -> conn
      _ -> 
        conn
        |> put_status(:forbidden)
        |> render(Apiv3.ErrorView, "forbidden.json", [msg: "bad master key"])
        |> halt
    end
  end

  defp has_master_key?(conn) do
    conn 
    |> get_req_header("simwms-master-key")
    |> List.first
    |> match_master_key?
  end

  defp match_master_key?(a) when is_binary(a) do
    String.strip(a) == @master_key
  end
  defp match_master_key?(_), do: false
end