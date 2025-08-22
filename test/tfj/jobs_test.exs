defmodule Tfj.JobsTest do
  use Tfj.DataCase

  alias Tfj.Jobs

  describe "jobs" do
    alias Tfj.Jobs.Job

    import Tfj.AccountsFixtures, only: [user_scope_fixture: 0]
    import Tfj.JobsFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_jobs/1 returns all scoped jobs" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      job = job_fixture(scope)
      other_job = job_fixture(other_scope)
      assert Jobs.list_jobs(scope) == [job]
      assert Jobs.list_jobs(other_scope) == [other_job]
    end

    test "get_job!/2 returns the job with given id" do
      scope = user_scope_fixture()
      job = job_fixture(scope)
      other_scope = user_scope_fixture()
      assert Jobs.get_job!(scope, job.id) == job
      assert_raise Ecto.NoResultsError, fn -> Jobs.get_job!(other_scope, job.id) end
    end

    test "create_job/2 with valid data creates a job" do
      valid_attrs = %{description: "some description", title: "some title"}
      scope = user_scope_fixture()

      assert {:ok, %Job{} = job} = Jobs.create_job(scope, valid_attrs)
      assert job.description == "some description"
      assert job.title == "some title"
      assert job.user_id == scope.user.id
    end

    test "create_job/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Jobs.create_job(scope, @invalid_attrs)
    end

    test "update_job/3 with valid data updates the job" do
      scope = user_scope_fixture()
      job = job_fixture(scope)
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %Job{} = job} = Jobs.update_job(scope, job, update_attrs)
      assert job.description == "some updated description"
      assert job.title == "some updated title"
    end

    test "update_job/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      job = job_fixture(scope)

      assert_raise MatchError, fn ->
        Jobs.update_job(other_scope, job, %{})
      end
    end

    test "update_job/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      job = job_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Jobs.update_job(scope, job, @invalid_attrs)
      assert job == Jobs.get_job!(scope, job.id)
    end

    test "delete_job/2 deletes the job" do
      scope = user_scope_fixture()
      job = job_fixture(scope)
      assert {:ok, %Job{}} = Jobs.delete_job(scope, job)
      assert_raise Ecto.NoResultsError, fn -> Jobs.get_job!(scope, job.id) end
    end

    test "delete_job/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      job = job_fixture(scope)
      assert_raise MatchError, fn -> Jobs.delete_job(other_scope, job) end
    end

    test "change_job/2 returns a job changeset" do
      scope = user_scope_fixture()
      job = job_fixture(scope)
      assert %Ecto.Changeset{} = Jobs.change_job(scope, job)
    end
  end
end
