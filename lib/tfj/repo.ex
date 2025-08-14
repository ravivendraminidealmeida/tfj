defmodule Tfj.Repo do
  use Ecto.Repo,
    otp_app: :tfj,
    adapter: Ecto.Adapters.SQLite3
end
