defmodule Apiv3 do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    Stripex.start

    children = [
      # Start the endpoint when the application starts
      supervisor(Apiv3.Endpoint, []),
      # Start the Ecto repository
      worker(Apiv3.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(Apiv3.Worker, [arg1, arg2, arg3]),
      supervisor(Apiv3.Stargate.WarpSupervisor, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Apiv3.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Apiv3.Endpoint.config_change(changed, removed)
    :ok
  end

  # Call this from iex -S mix phoenix.server to get login credentials
  def gimme_dev_credentials do
    import Ecto.Query, only: [from: 2]
    import Ecto.Model, only: [assoc: 2]
    alias Apiv3.Repo
    query = from a in Apiv3.Account, 
      select: a, 
      limit: 1, 
      order_by: [desc: a.id]
  
    account = query |> Repo.one!
    user = account |> assoc(:user) |> Repo.one!
    %{email: user.email, user: user.remember_token, token: account.permalink}
  end
end
