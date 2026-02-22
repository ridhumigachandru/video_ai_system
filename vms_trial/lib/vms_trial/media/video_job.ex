defmodule VmsTrial.Media.VideoJob do
  use Ecto.Schema
  import Ecto.Changeset

  schema "video_jobs" do
    field :stored_path, :string
    field :file_format, :string
    field :start_sec, :integer
    field :end_sec, :integer
    field :clip_path, :string
    field :ai_result, :map

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(video_job, attrs) do
    video_job
    |> cast(attrs, [:stored_path, :file_format, :start_sec, :end_sec, :clip_path, :ai_result])
    |> validate_required([:start_sec, :end_sec])
  end
end
