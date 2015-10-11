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
    query = from e in Apiv3.Employee, 
      select: e, 
      limit: 1, 
      order_by: [desc: e.id]
  
    employee = Apiv3.Repo.one! query
    account = employee |> Ecto.Model.assoc(:account) |> Apiv3.Repo.one!
    %{email: employee.email, token: account.permalink}
  end
end
