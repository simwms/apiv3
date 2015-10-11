defmodule Apiv3.Stargate do
  @moduledoc """
  Stargate is a simple and local implementation of a job server.

  But, because I'm a trekkie and a massive faggot, all the function names
  are in incomprehensible Treknobabble
  """

  def warp_sync(core) do
    core |> Apiv3.Stargate.WarpSupervisor.rift_spacetime
  end

  def warp_sync(core, pid) do
    core |> Apiv3.Stargate.WarpSupervisor.rift_spacetime(pid)
  end
  
end