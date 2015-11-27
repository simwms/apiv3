defmodule Apiv3.Router do
  use Apiv3.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :secure_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Apiv3.Plugs.UserSession
    plug Apiv3.Plugs.AccountSession
  end

  pipeline :admin do
    plug :accepts, ["json"]
    plug Apiv3.Plugs.MasterKey
  end

  pipeline :apia do
    plug :accepts, ["json"]
    plug :fetch_session
    plug Apiv3.Plugs.UserSession
    plug Apiv3.Plugs.AccountSession
    plug Apiv3.Plugs.ManagementAuthorization
  end

  pipeline :apiz do
    plug :accepts, ["json"]
    plug :fetch_session
    plug Apiv3.Plugs.UserSession
    plug Apiv3.Plugs.AccountSession
  end

  pipeline :apix do
    plug :accepts, ["json"]
    plug :fetch_session
    plug Apiv3.Plugs.UserSession
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/", Apiv3 do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/print", Apiv3 do
    pipe_through :browser # Use the default browser stack

    resources "/reports", ReportController, only: [:show]
  end

  @moduledoc """
  Requires admin master key
  """
  scope "/admin", Apiv3 do
    pipe_through :admin
    resources "/sanity", SanityController, only: [:show], singleton: true
    resources "/service_plans", ServicePlanController, only: [:update, :create, :delete]
  end

  @moduledoc """
  requires user account management authorization
  """
  scope "/apia", Apiv3 do
    pipe_through :apia
    resources "/cameras", CameraController, except: [:edit, :new]
    resources "/tiles", TileController, except: [:edit, :new]
    resources "/points", PointController, except: [:edit, :new]
    resources "/lines", LineController, except: [:edit, :new]
    resources "/payment_subscription", PaymentSubscriptionController, only: [:update, :show], singleton: true
    resources "/employees", EmployeeController, only: [:show, :index, :update, :create, :delete]
  end

  @moduledoc """
  requires user account authentication
  """
  scope "/apiz", Apiv3 do
    pipe_through :apiz
    resources "/cameras", CameraController, only: [:index, :show, :update]
    resources "/tiles", TileController, only: [:index, :show, :update]
    resources "/points", PointController, only: [:index, :show, :update]
    resources "/lines", LineController, only: [:index, :show, :update]
    resources "/appointments", AppointmentController, except: [:edit, :new]
    resources "/trucks", TruckController, except: [:edit, :new]
    resources "/weightickets", WeighticketController, except: [:edit, :new]
    resources "/batches", BatchController, except: [:edit, :new]
    resources "/employees", EmployeeController, only: [:show, :index, :update]
    resources "/batch_relationships", BatchRelationshipController, except: [:edit, :new]
    resources "/appointment_relationships", AppointmentRelationshipController, except: [:edit, :new]
    resources "/pictures", PictureController, only: [:create]
    resources "/reports", ReportController, only: [:create]
  end

  @moduledoc """
  requires user authentication
  """
  scope "/apix", Apiv3 do
    pipe_through :apix
    resources "/employees", UserEmployeeController, only: [:show]
    resources "/account_details", AccountDetailController, only: [:show]
    resources "/accounts", AccountController, only: [:create, :update, :index, :show, :delete]
    resources "/session", SessionController, only: [:delete, :show], singleton: true
    resources "/sessions", SessionController, only: [:delete, :show]
  end

  @moduledoc """
  anonymous api, no login required
  """
  scope "/api", Apiv3 do
    pipe_through :api
    resources "/session", SessionController, only: [:create], singleton: true
    resources "/sessions", SessionController, only: [:create]
    resources "/users", UserController, only: [:create]
    resources "/service_plans", ServicePlanController, only: [:index, :show]    
  end
end