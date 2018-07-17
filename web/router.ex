defmodule Comindivion.Router do
  use Comindivion.Web, :router

  pipeline :revive_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Comindivion.Auth.CurrentUser
  end

  pipeline :check_auth do
    plug Comindivion.Plug.CheckAuth
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug NavigationHistory.Tracker
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  # All actions in scope require a logged in user
  scope "/", Comindivion do
    pipe_through [:browser, :revive_auth, :check_auth]

    resources "/mind_objects", MindObjectController
    resources "/predicates", PredicateController
    resources "/subject_object_relations", SubjectObjectRelationController
    resources "/similarity", SimilarityController, only: [:index]

    get "/i", InteractiveController, :index
  end

  # All actions in scope partially require or not required a logged in user
  scope "/", Comindivion do
    pipe_through [:browser, :revive_auth]

    resources "/", PageController, only: [:index]
    resources "/about", AboutController, only: [:index]
    resources "/users", UserController, only: [:show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

   # All API actions required a logged in user
  scope "/api", Comindivion.Api do
    pipe_through [:api, :revive_auth, :check_auth]

    resources "/i", InteractiveController, only: [:index]

    resources "/mind_objects", MindObjectController, only: [:show, :create, :update, :delete]

    # Crutches for simplify construction of a request into js
    post "/mind_objects/:id", MindObjectController, :update
    post "/positions/:mind_object_id", PositionController, :update

    resources "/subject_object_relations", SubjectObjectRelationController, only: [:create, :update, :delete]

    # Crutches for simplify construction of a request into js
    post "/subject_object_relations/:id", SubjectObjectRelationController, :update

    resources "/search", SearchController, only: [:index]
  end
end
