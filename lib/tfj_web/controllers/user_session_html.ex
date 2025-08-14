defmodule TfjWeb.UserSessionHTML do
  use TfjWeb, :html

  embed_templates "user_session_html/*"

  defp local_mail_adapter? do
    Application.get_env(:tfj, Tfj.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
