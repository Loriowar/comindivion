defmodule Comindivion.Router do
  use Comindivion.Web, :router

  pipeline :auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Comindivion.Auth.CurrentUser
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

  scope "/", Comindivion do
    pipe_through [:browser, :auth]

    get "/", PageController, :index

    resources "/mind_objects", MindObjectController
    resources "/predicates", PredicateController
    resources "/subject_object_relations", SubjectObjectRelationController
    resources "/similarity", SimilarityController, only: [:index]
    resources "/users", UserController, only: [:show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/about", AboutController, only: [:index]

    get "/i", InteractiveController, :index
  end

   scope "/api", Comindivion.Api do
     pipe_through [:api, :auth]

     get "/i/f", InteractiveController, :fetch

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
