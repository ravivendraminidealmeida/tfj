defmodule Tfj.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  alias Tfj.Repo

  alias Tfj.Jobs.Job
  alias Tfj.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any job changes.

  The broadcasted messages match the pattern:

    * {:created, %Job{}}
    * {:updated, %Job{}}
    * {:deleted, %Job{}}

  """
  def subscribe_jobs(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Tfj.PubSub, "user:#{key}:jobs")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Tfj.PubSub, "user:#{key}:jobs", message)
  end

  @doc """
  Returns the list of jobs.

  ## Examples

      iex> list_jobs(scope)
      [%Job{}, ...]

  """
  def list_jobs(%Scope{} = scope) do
    Repo.all_by(Job, user_id: scope.user.id)
  end

  @doc """
  Gets a single job.

  Raises `Ecto.NoResultsError` if the Job does not exist.

  ## Examples

      iex> get_job!(scope, 123)
      %Job{}

      iex> get_job!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_job!(%Scope{} = scope, id) do
    Repo.get_by!(Job, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a job.

  ## Examples

      iex> create_job(scope, %{field: value})
      {:ok, %Job{}}

      iex> create_job(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job(%Scope{} = scope, attrs) do
    with {:ok, job = %Job{}} <-
           %Job{}
           |> Job.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast(scope, {:created, job})
      {:ok, job}
    end
  end

  @doc """
  Updates a job.

  ## Examples

      iex> update_job(scope, job, %{field: new_value})
      {:ok, %Job{}}

      iex> update_job(scope, job, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job(%Scope{} = scope, %Job{} = job, attrs) do
    true = job.user_id == scope.user.id

    with {:ok, job = %Job{}} <-
           job
           |> Job.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, job})
      {:ok, job}
    end
  end

  @doc """
  Deletes a job.

  ## Examples

      iex> delete_job(scope, job)
      {:ok, %Job{}}

      iex> delete_job(scope, job)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job(%Scope{} = scope, %Job{} = job) do
    true = job.user_id == scope.user.id

    with {:ok, job = %Job{}} <-
           Repo.delete(job) do
      broadcast(scope, {:deleted, job})
      {:ok, job}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job changes.

  ## Examples

      iex> change_job(scope, job)
      %Ecto.Changeset{data: %Job{}}

  """
  def change_job(%Scope{} = scope, %Job{} = job, attrs \\ %{}) do
    true = job.user_id == scope.user.id

    Job.changeset(job, attrs, scope)
  end
end
