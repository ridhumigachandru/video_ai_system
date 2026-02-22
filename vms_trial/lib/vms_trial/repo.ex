defmodule VmsTrial.Repo do
  use Ecto.Repo,
    otp_app: :vms_trial,
    adapter: Ecto.Adapters.Postgres
end
