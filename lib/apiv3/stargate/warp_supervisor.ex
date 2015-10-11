defmodule Apiv3.Stargate.WarpSupervisor do
  alias Apiv3.Stargate.RiftCore
  use Supervisor

  # Client-API
  def start_link(opts\\[name: __MODULE__, restart: :transient]) do
    Task.Supervisor.start_link(opts)
  end

  def rift_spacetime(core) do
    __MODULE__ |> Task.Supervisor.start_child(RiftCore, :sync, [core])
  end

  def rift_spacetime(core, pid) do
    __MODULE__ |> Task.Supervisor.start_child(RiftCore, :sync_callback, [core, pid])
  end

  # Server
  def init(x), do: x
end