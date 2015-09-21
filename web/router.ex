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
    plug Apiv3.Plugs.AccountSession
  end

  pipeline :internal_api do
    plug :accepts, ["json"]
    plug Apiv3.Plugs.MasterKey
  end

  pipeline :secure_api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug Apiv3.Plugs.AccountSession
  end

  scope "/", Apiv3 do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/print", Apiv3 do
    pipe_through :secure_browser # Use the default browser stack
    get "/reports", ReportController, :index
  end

  scope "/internal", Apiv3 do
    pipe_through :internal_api
    resources "/sanity", SanityController, only: [:show], singleton: true
    resources "/accounts", AccountController, only: [:create, :update]
    resources "/service_plans", ServicePlanController, only: [:update]
  end

  scope "/apiv3", Apiv3 do
    pipe_through :secure_api
    resources "/cameras", CameraController, except: [:edit, :new]
    resources "/tiles", TileController, except: [:edit, :new]
    resources "/appointments", AppointmentController, except: [:edit, :new]
    resources "/trucks", TruckController, except: [:edit, :new]
    resources "/weightickets", WeighticketController, except: [:edit, :new]
    resources "/batches", BatchController, except: [:edit, :new]
    resources "/employees", EmployeeController, except: [:edit, :new]
    resources "/batch_relationships", BatchRelationshipController, except: [:edit, :new]
    resources "/appointment_relationships", AppointmentRelationshipController, except: [:edit, :new]
    resources "/pictures", PictureController, only: [:create]
    resources "/account", AccountController, only: [:show], singleton: true, name: "my_account"
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