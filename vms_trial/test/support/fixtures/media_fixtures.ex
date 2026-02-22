defmodule VmsTrial.MediaFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VmsTrial.Media` context.
  """

  @doc """
  Generate a video_job.
  """
  def video_job_fixture(attrs \\ %{}) do
    {:ok, video_job} =
      attrs
      |> Enum.into(%{
        ai_result: %{},
        clip_path: "some clip_path",
        end_sec: 42,
        file_format: "some file_format",
        start_sec: 42,
        stored_path: "some stored_path"
      })
      |> VmsTrial.Media.create_video_job()

    video_job
  end
end
