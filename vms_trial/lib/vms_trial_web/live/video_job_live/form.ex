defmodule VmsTrialWeb.VideoJobLive.Form do
  use VmsTrialWeb, :live_view

  @original_dir "priv/static/uploads/original"
  @clip_dir "priv/static/uploads/clips"

  @impl true
  def mount(_params, _session, socket) do
    File.mkdir_p!(@original_dir)
    File.mkdir_p!(@clip_dir)

    {:ok,
     socket
     |> assign(:video_url, nil)
     |> assign(:uploaded_path, nil)
     |> assign(:processing, false)
     |> allow_upload(:video,
       accept: ~w(.mp4),
       max_entries: 1,
       max_file_size: 200_000_000,
       auto_upload: true,
       progress: &handle_progress/3
     )}
  end

  # --------------------------
  # Upload
  # --------------------------
  def handle_progress(:video, entry, socket) do
    if entry.done? do
      uploaded =
        consume_uploaded_entries(socket, :video, fn %{path: path}, entry ->
          dest =
            Path.join(@original_dir,
              "#{System.unique_integer()}_#{entry.client_name}"
            )

          File.cp!(path, dest)
          {:ok, dest}
        end)

      {:noreply, assign(socket, :uploaded_path, List.first(uploaded))}
    else
      {:noreply, socket}
    end
  end

  def handle_event("noop", _params, socket), do: {:noreply, socket}

  # --------------------------
  # Save (Non-blocking)
  # --------------------------
  @impl true
  def handle_event("save", %{"start_sec" => s, "end_sec" => e}, socket) do
    if socket.assigns.uploaded_path == nil do
      {:noreply, put_flash(socket, :error, "Upload not completed")}
    else
      # Start processing state
      send(self(), {:process_video, s, e})
      {:noreply, assign(socket, :processing, true)}
    end
  end

  # --------------------------
  # Heavy processing in handle_info
  # --------------------------
  @impl true
  def handle_info({:process_video, s, e}, socket) do
    stored_path = socket.assigns.uploaded_path
    clip_path = Path.join(@clip_dir, "temp_clip.mp4")

    System.cmd("ffmpeg", [
      "-y",
      "-i", stored_path,
      "-ss", s,
      "-to", e,
      "-c", "copy",
      clip_path
    ])

    annotated_path = call_ai_service(clip_path)

    {:noreply,
     socket
     |> assign(:video_url, "/uploads/clips/#{Path.basename(annotated_path)}?ts=#{System.system_time()}")
     |> assign(:processing, false)}
  end

  # --------------------------
  # AI Call
  # --------------------------
  defp call_ai_service(clip_path) do
    url = "http://localhost:8000/detect"

    multipart = {
      :multipart,
      [
        {:file, clip_path,
         {"form-data", [name: "file", filename: Path.basename(clip_path)]},
         [{"Content-Type", "video/mp4"}]}
      ]
    }

    {:ok, %HTTPoison.Response{status_code: 200, body: body}} =
      HTTPoison.post(url, multipart, [], recv_timeout: 300_000)

    annotated_path = Path.join(@clip_dir, "annotated.mp4")
    File.write!(annotated_path, body, [:binary])

    annotated_path
  end

  # --------------------------
  # Render
  # --------------------------
  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto py-10">

      <h2 class="text-2xl font-bold">Upload Video</h2>

      <.form for={%{}} phx-submit="save" phx-change="noop" multipart class="space-y-6">

        <div>
          <.live_file_input upload={@uploads.video} />

          <%= if @uploaded_path do %>
            <p class="text-green-600 mt-2">Upload completed ✓</p>
          <% end %>
        </div>

        <input type="number" name="start_sec" required placeholder="Start second"
               class="w-full border rounded px-3 py-2"/>

        <input type="number" name="end_sec" required placeholder="End second"
               class="w-full border rounded px-3 py-2"/>

        <button type="submit"
                disabled={@processing}
                class={
                  "px-6 py-2 rounded text-white " <>
                  if @processing, do: "bg-gray-400", else: "bg-blue-600"
                }>
          <%= if @processing do %>
            Processing...
          <% else %>
            Process
          <% end %>
        </button>

      </.form>

      <%= if @video_url do %>
        <div class="mt-10 border-t pt-6">
          <h3 class="font-semibold text-lg">Annotated Video</h3>

          <video width="600" controls class="mt-3 rounded shadow">
            <source src={@video_url} type="video/mp4">
          </video>
        </div>
      <% end %>

    </div>
    """
  end
end
