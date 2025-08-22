defmodule Tfj.JobsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tfj.Jobs` context.
  """

  @doc """
  Generate a job.
  """
  def job_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        description: "some description",
        title: "some title"
      })

    {:ok, job} = Tfj.Jobs.create_job(scope, attrs)
    job
  end
end
