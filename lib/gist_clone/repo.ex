defmodule GistClone.Repo do
  use Ecto.Repo,
    otp_app: :gist_clone,
    adapter: Ecto.Adapters.Postgres
end
