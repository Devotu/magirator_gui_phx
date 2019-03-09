defmodule MagiratorGuiPhxWeb.MainController do
  use MagiratorGuiPhxWeb, :controller

  def main(conn, _params) do
    render conn, "main.html"
  end
end