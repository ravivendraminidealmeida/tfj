defmodule TfjWeb.PageController do
  use TfjWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
