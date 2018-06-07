defmodule Comindivion.Router do
  use Comindivion.Web, :router

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
  end

  scope "/", Comindivion do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/mind_objects", MindObjectController
    resources "/predicates", PredicateController
    resources "/subject_object_relations", SubjectObjectRelationController

    get "/i", InteractiveController, :index
  end

  # Other scopes may use custom stacks.
   scope "/api", Comindivion.Api do
     pipe_through :api

     get "/i/f", InteractiveController, :fetch

     resources "/mind_objects", MindObjectController, only: [:show, :create, :update, :delete]

     # Crutches for simplify construction of a request into js
     post "/mind_objects/:id", MindObjectController, :update
     post "/positions/:mind_object_id", PositionController, :update

     resources "/subject_object_relations", SubjectObjectRelationController, only: [:create, :delete]
   end
end
