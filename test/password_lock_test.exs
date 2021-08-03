defmodule PasswordLockTest do
  use ExUnit.Case
  doctest PasswordLock

  setup do
    {:ok, server_pid} = PasswordLock.start_link("foo")
    {:ok, server: server_pid}
  end

  describe "unlock/2" do
    test "returns :ok when it unlocks account successfully. ", %{server: pid} do
      assert :ok == PasswordLock.unlock(pid, "foo")
    end

    test "returns {:error,'wrongpassword'} on wrong password", %{server: pid} do
      assert {:error, "wrongpassword"} == PasswordLock.unlock(pid, "bar")
    end
  end

  describe "reset/2" do
    test "returns :ok on successful password reset", %{server: pid} do
      assert :ok == PasswordLock.reset(pid, {"foo", "bar"})
    end

    test "returns an error on reset failure", %{server: pid} do
      assert {:error, "wrongpassword"} == PasswordLock.reset(pid, {"hello", "bar"})
    end
  end
end
