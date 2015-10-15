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
    pipe_through :secure_browser # Use the default browser stack
    get "/reports", ReportController, :index
  end

  @doc """
  Requires admin master key
  """
  scope "/admin", Apiv3 do
    pipe_through :admin
    resources "/sanity", SanityController, only: [:show], singleton: true
    resources "/service_plans", ServicePlanController, only: [:update, :create, :delete]
  end

  @doc """
  requires user account management authorization
  """
  scope "/apia", Apiv3 do
    pipe_through :apia
    resources "/cameras", CameraController, except: [:edit, :new]
    resources "/tiles", TileController, except: [:edit, :new]
    resources "/payment_subscription", PaymentSubscriptionController, only: [:update, :show], singleton: true
    resources "/employees", EmployeeController, except: [:edit, :new]
  end

  @doc """
  requires user account authentication
  """
  scope "/apiz", Apiv3 do
    pipe_through :apiz
    resources "/cameras", CameraController, only: [:index, :show, :update]
    resources "/tiles", TileController, only: [:index, :show, :update]
    resources "/appointments", AppointmentController, except: [:edit, :new]
    resources "/trucks", TruckController, except: [:edit, :new]
    resources "/weightickets", WeighticketController, except: [:edit, :new]
    resources "/batches", BatchController, except: [:edit, :new]
    resources "/employees", EmployeeController, only: [:show, :index, :update]
    resources "/batch_relationships", BatchRelationshipController, except: [:edit, :new]
    resources "/appointment_relationships", AppointmentRelationshipController, except: [:edit, :new]
    resources "/pictures", PictureController, only: [:create]
  end

  @doc """
  requires user authentication
  """
  scope "/apix", Apiv3 do
    pipe_through :apix
    resources "/account_details", AccountDetailController, only: [:show]
    resources "/accounts", AccountController, only: [:create, :update, :index, :show]
    resources "/session", SessionController, only: [:delete, :show], singleton: true
    resources "/sessions", SessionController, only: [:delete]
  end

  @doc """
  anonymous api, no login required
  """
  scope "/api", Apiv3 do
    pipe_through :api
    resources "/session", SessionController, only: [:create], singleton: true
    resources "/users", UserController, only: [:create]
    resources "/service_plans", ServicePlanController, only: [:index, :show]    
  end
  @moduledoc """
  「鼓動が止むまで傍にいる」なんて
  違える約束はせず　ただあなたといたい

  「掴めないものほど欲しくなる」と云うなら
  あたしはあなたのものに　なれなくてもいいの

  あなたと染まる　季節　沈んでいく
  あたしは兎角　微熱に喘いでいた
  聞き慣れた声、手のひら　どこにもいない
  結んだ指の先　ほどけた

  時が経つことも　惜しくなるようで
  運命なんて馬鹿らしいことすら　信じたくなる

  橙の夕日に世界が溺れていく
  あなたと二人肩を並べて見とれていた

  少し背伸びをしたまま大人になるあたし

  あなたが染める　影は　消えていく
  愛した街も　人も　いなくなる
  たったふたりきり　世界に落ちていく
  そんな気がしていた

  強がりもワガママも　照れ隠しの言葉も
  抱きしめた体さえ　この手をすり抜けるの
  悔いたっておそい　もうあなたはいない

  あなたと染まる　季節　沈んでいく
  あたしは兎角　微熱に喘いでいた
  聞き慣れた声、手のひら　今はどこで

  さよなら愛した

  あなたに染まり　愛(かな)し　恋い焦がれ
  あたしは同じ色を重ねていく
  たったひとりきり　辿った色褪せない
  あなたの指の先　ほどけた"
  """
end