defmodule VmsTrialWeb.VideoJobLiveTest do
  use VmsTrialWeb.ConnCase

  import Phoenix.LiveViewTest
  import VmsTrial.MediaFixtures

  @create_attrs %{stored_path: "some stored_path", file_format: "some file_format", start_sec: 42, end_sec: 42, clip_path: "some clip_path", ai_result: %{}}
  @update_attrs %{stored_path: "some updated stored_path", file_format: "some updated file_format", start_sec: 43, end_sec: 43, clip_path: "some updated clip_path", ai_result: %{}}
  @invalid_attrs %{stored_path: nil, file_format: nil, start_sec: nil, end_sec: nil, clip_path: nil, ai_result: nil}
  defp create_video_job(_) do
    video_job = video_job_fixture()

    %{video_job: video_job}
  end

  describe "Index" do
    setup [:create_video_job]

    test "lists all video_jobs", %{conn: conn, video_job: video_job} do
      {:ok, _index_live, html} = live(conn, ~p"/video_jobs")

      assert html =~ "Listing Video jobs"
      assert html =~ video_job.stored_path
    end

    test "saves new video_job", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/video_jobs")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Video job")
               |> render_click()
               |> follow_redirect(conn, ~p"/video_jobs/new")

      assert render(form_live) =~ "New Video job"

      assert form_live
             |> form("#video_job-form", video_job: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#video_job-form", video_job: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/video_jobs")

      html = render(index_live)
      assert html =~ "Video job created successfully"
      assert html =~ "some stored_path"
    end

    test "updates video_job in listing", %{conn: conn, video_job: video_job} do
      {:ok, index_live, _html} = live(conn, ~p"/video_jobs")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#video_jobs-#{video_job.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/video_jobs/#{video_job}/edit")

      assert render(form_live) =~ "Edit Video job"

      assert form_live
             |> form("#video_job-form", video_job: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#video_job-form", video_job: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/video_jobs")

      html = render(index_live)
      assert html =~ "Video job updated successfully"
      assert html =~ "some updated stored_path"
    end

    test "deletes video_job in listing", %{conn: conn, video_job: video_job} do
      {:ok, index_live, _html} = live(conn, ~p"/video_jobs")

      assert index_live |> element("#video_jobs-#{video_job.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#video_jobs-#{video_job.id}")
    end
  end

  describe "Show" do
    setup [:create_video_job]

    test "displays video_job", %{conn: conn, video_job: video_job} do
      {:ok, _show_live, html} = live(conn, ~p"/video_jobs/#{video_job}")

      assert html =~ "Show Video job"
      assert html =~ video_job.stored_path
    end

    test "updates video_job and returns to show", %{conn: conn, video_job: video_job} do
      {:ok, show_live, _html} = live(conn, ~p"/video_jobs/#{video_job}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/video_jobs/#{video_job}/edit?return_to=show")

      assert render(form_live) =~ "Edit Video job"

      assert form_live
             |> form("#video_job-form", video_job: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#video_job-form", video_job: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/video_jobs/#{video_job}")

      html = render(show_live)
      assert html =~ "Video job updated successfully"
      assert html =~ "some updated stored_path"
    end
  end
end
