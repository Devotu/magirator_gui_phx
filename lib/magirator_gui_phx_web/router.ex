defmodule MagiratorGuiPhxWeb.Router do
  use MagiratorGuiPhxWeb, :router

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

  scope "/magirator", MagiratorGuiPhxWeb do
    pipe_through :browser # Use the default browser stack

    get "/", MainController, :main

    get "/players/new", PlayerController, :new
    post "/players", PlayerController, :create

    get "/decks/new", DeckController, :new
    get "/decks/:id", DeckController, :show
    get "/decks", DeckController, :index
    post "/decks", DeckController, :create

    get "/games/new", GameController, :new
    post "/games", GameController, :create
  end

  scope "/", MagiratorGuiPhxWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end
end
