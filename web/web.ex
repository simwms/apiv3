defmodule Apiv3.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Apiv3.Web, :controller
      use Apiv3.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Model
      use Timex.Ecto.Timestamps
      alias Apiv3.Repo
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias Apiv3.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 2]
      import Apiv3.AccountSessionHelper, only: [current_account: 1, logout!: 1]
      import Apiv3.UserSessionHelper, only: [current_user: 1, current_user!: 1]
      import Apiv3.Router.Helpers
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Apiv3.Router.Helpers
      import Fox.RecordExt
      import Fox.DictExt

      def render_many([], _), do: []
      def render_many([model|_]=collection, template) when is_binary(template) do
        view = view_for_model(model)
        render_many(collection, view, template)
      end

      def render_one(model, template) when is_binary(template) do
        view = view_for_model model
        render_one(model, view, template)
      end
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Apiv3.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 2]

    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
