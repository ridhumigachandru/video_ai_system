defmodule VmsTrialWeb.VideoJobLive.Index do
  use VmsTrialWeb, :live_view

  alias VmsTrial.Media

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Video jobs
        <:actions>
          <.button variant="primary" navigate={~p"/video_jobs/new"}>
            <.icon name="hero-plus" /> New Video job
          </.button>
        </:actions>
      </.header>

      <.table
        id="video_jobs"
        rows={@streams.video_jobs}
        row_click={fn {_id, video_job} -> JS.navigate(~p"/video_jobs/#{video_job}") end}
      >
        <:col :let={{_id, video_job}} label="Stored path">{video_job.stored_path}</:col>
        <:col :let={{_id, video_job}} label="File format">{video_job.file_format}</:col>
        <:col :let={{_id, video_job}} label="Start sec">{video_job.start_sec}</:col>
        <:col :let={{_id, video_job}} label="End sec">{video_job.end_sec}</:col>
        <:col :let={{_id, video_job}} label="Clip path">{video_job.clip_path}</:col>
        <:col :let={{_id, video_job}} label="Ai result">{video_job.ai_result}</:col>
        <:action :let={{_id, video_job}}>
          <div class="sr-only">
            <.link navigate={~p"/video_jobs/#{video_job}"}>Show</.link>
          </div>
          <.link navigate={~p"/video_jobs/#{video_job}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, video_job}}>
          <.link
            phx-click={JS.push("delete", value: %{id: video_job.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Video jobs")
     |> stream(:video_jobs, list_video_jobs())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    video_job = Media.get_video_job!(id)
    {:ok, _} = Media.delete_video_job(video_job)

    {:noreply, stream_delete(socket, :video_jobs, video_job)}
  end

  defp list_video_jobs() do
    Media.list_video_jobs()
  end
end
