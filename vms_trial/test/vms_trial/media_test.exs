defmodule VmsTrial.MediaTest do
  use VmsTrial.DataCase

  alias VmsTrial.Media

  describe "video_jobs" do
    alias VmsTrial.Media.VideoJob

    import VmsTrial.MediaFixtures

    @invalid_attrs %{stored_path: nil, file_format: nil, start_sec: nil, end_sec: nil, clip_path: nil, ai_result: nil}

    test "list_video_jobs/0 returns all video_jobs" do
      video_job = video_job_fixture()
      assert Media.list_video_jobs() == [video_job]
    end

    test "get_video_job!/1 returns the video_job with given id" do
      video_job = video_job_fixture()
      assert Media.get_video_job!(video_job.id) == video_job
    end

    test "create_video_job/1 with valid data creates a video_job" do
      valid_attrs = %{stored_path: "some stored_path", file_format: "some file_format", start_sec: 42, end_sec: 42, clip_path: "some clip_path", ai_result: %{}}

      assert {:ok, %VideoJob{} = video_job} = Media.create_video_job(valid_attrs)
      assert video_job.stored_path == "some stored_path"
      assert video_job.file_format == "some file_format"
      assert video_job.start_sec == 42
      assert video_job.end_sec == 42
      assert video_job.clip_path == "some clip_path"
      assert video_job.ai_result == %{}
    end

    test "create_video_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create_video_job(@invalid_attrs)
    end

    test "update_video_job/2 with valid data updates the video_job" do
      video_job = video_job_fixture()
      update_attrs = %{stored_path: "some updated stored_path", file_format: "some updated file_format", start_sec: 43, end_sec: 43, clip_path: "some updated clip_path", ai_result: %{}}

      assert {:ok, %VideoJob{} = video_job} = Media.update_video_job(video_job, update_attrs)
      assert video_job.stored_path == "some updated stored_path"
      assert video_job.file_format == "some updated file_format"
      assert video_job.start_sec == 43
      assert video_job.end_sec == 43
      assert video_job.clip_path == "some updated clip_path"
      assert video_job.ai_result == %{}
    end

    test "update_video_job/2 with invalid data returns error changeset" do
      video_job = video_job_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.update_video_job(video_job, @invalid_attrs)
      assert video_job == Media.get_video_job!(video_job.id)
    end

    test "delete_video_job/1 deletes the video_job" do
      video_job = video_job_fixture()
      assert {:ok, %VideoJob{}} = Media.delete_video_job(video_job)
      assert_raise Ecto.NoResultsError, fn -> Media.get_video_job!(video_job.id) end
    end

    test "change_video_job/1 returns a video_job changeset" do
      video_job = video_job_fixture()
      assert %Ecto.Changeset{} = Media.change_video_job(video_job)
    end
  end
end
