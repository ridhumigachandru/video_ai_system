defmodule VmsTrialWeb.VideoJobLive.Show do
  use VmsTrialWeb, :live_view

  alias VmsTrial.Media

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Video job {@video_job.id}
        <:subtitle>This is a video_job record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/video_jobs"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/video_jobs/#{@video_job}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit video_job
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Stored path">{@video_job.stored_path}</:item>
        <:item title="File format">{@video_job.file_format}</:item>
        <:item title="Start sec">{@video_job.start_sec}</:item>
        <:item title="End sec">{@video_job.end_sec}</:item>
        <:item title="Clip path">{@video_job.clip_path}</:item>
        <:item title="Ai result">{@video_job.ai_result}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Video job")
     |> assign(:video_job, Media.get_video_job!(id))}
  end
end
