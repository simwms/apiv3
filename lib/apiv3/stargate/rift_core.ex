defmodule Apiv3.Stargate.RiftCore do
  
  def sync(core) do
    core.()
  end

  def sync_callback(core, pid) do
    pid |> send({:try, core})
    pid |> send({:done, sync(core)})
  end
end