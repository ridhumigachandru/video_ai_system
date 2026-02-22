defmodule VmsTrialWeb.PageController do
  use VmsTrialWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
