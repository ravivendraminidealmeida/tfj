defmodule TfjWeb.JobController do
  use TfjWeb, :controller

  alias Req
  alias Tfj.Jobs
  alias Tfj.Crawlers.Linkedin

  def find_job(conn, params) do
    job_info = %{
      user_linkedin: params["user_linkedin"],
      job_annoucement_link: params["job_annoucement_link"]
    }

    Linkedin.init(job_info.user_linkedin)
    Crawly.Engine.start_spider(Linkedin)

    redirect(conn, to: ~p"/jobs")
  end

  def index(conn, _params) do
    jobs = Jobs.list_jobs(conn.assigns.current_scope)
    render(conn, :index, jobs: jobs)
  end

end
