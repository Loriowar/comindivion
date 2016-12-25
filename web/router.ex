defmodule Comindivion.Router do
  use Comindivion.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
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
  end

  # Other scopes may use custom stacks.
  # scope "/api", Comindivion do
  #   pipe_through :api
  # end
end
