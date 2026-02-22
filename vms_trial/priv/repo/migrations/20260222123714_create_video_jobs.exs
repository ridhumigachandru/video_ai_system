defmodule VmsTrial.Repo.Migrations.CreateVideoJobs do
  use Ecto.Migration

  def change do
    create table(:video_jobs) do
      add :stored_path, :string
      add :file_format, :string
      add :start_sec, :integer
      add :end_sec, :integer
      add :clip_path, :string
      add :ai_result, :map

      timestamps(type: :utc_datetime)
    end
  end
end
