defmodule VmsTrial.Media do
  @moduledoc """
  The Media context.
  """

  import Ecto.Query, warn: false
  alias VmsTrial.Repo

  alias VmsTrial.Media.VideoJob

  @doc """
  Returns the list of video_jobs.

  ## Examples

      iex> list_video_jobs()
      [%VideoJob{}, ...]

  """
  def list_video_jobs do
    Repo.all(VideoJob)
  end

  @doc """
  Gets a single video_job.

  Raises `Ecto.NoResultsError` if the Video job does not exist.

  ## Examples

      iex> get_video_job!(123)
      %VideoJob{}

      iex> get_video_job!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video_job!(id), do: Repo.get!(VideoJob, id)

  @doc """
  Creates a video_job.

  ## Examples

      iex> create_video_job(%{field: value})
      {:ok, %VideoJob{}}

      iex> create_video_job(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video_job(attrs) do
    %VideoJob{}
    |> VideoJob.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a video_job.

  ## Examples

      iex> update_video_job(video_job, %{field: new_value})
      {:ok, %VideoJob{}}

      iex> update_video_job(video_job, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video_job(%VideoJob{} = video_job, attrs) do
    video_job
    |> VideoJob.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a video_job.

  ## Examples

      iex> delete_video_job(video_job)
      {:ok, %VideoJob{}}

      iex> delete_video_job(video_job)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video_job(%VideoJob{} = video_job) do
    Repo.delete(video_job)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video_job changes.

  ## Examples

      iex> change_video_job(video_job)
      %Ecto.Changeset{data: %VideoJob{}}

  """
  def change_video_job(%VideoJob{} = video_job, attrs \\ %{}) do
    VideoJob.changeset(video_job, attrs)
  end
end
