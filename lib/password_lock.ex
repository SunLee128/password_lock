defmodule PasswordLock do
  use GenServer

  # -------------#
  # Client - API #
  # -------------#
  def start_link(password) do
    GenServer.start_link(__MODULE__, password, [])
  end

  def unlock(server_pid, password) do
    GenServer.call(server_pid, {:unlock, password})
  end

  def reset(server_pid, {old_password, new_password}) do
    GenServer.call(server_pid, {:reset, {old_password, new_password}})
  end

  ## ---------- ##
  # Server - Callbacks #
  ## -----------##
  def init(password) do
    {:ok, [password]}
  end

  def handle_call({:reset, {old_password, new_password}}, _from, passwords) do
    case old_password in passwords do
      true ->
        new_state = List.delete(passwords, old_password)
        {:reply, :ok, [new_password | new_state]}

      _ ->
        write_to_logfile(new_password)
        {:reply, {:error, "wrongpassword"}, passwords}
    end
  end

  def handle_call({:unlock, password}, _from, passwords) do
    case password in passwords do
      true ->
        # {:reply, return_value, new_state}
        {:reply, :ok, passwords}

      _ ->
        write_to_logfile(password)
        {:reply, {:error, "wrongpassword"}, passwords}
    end
  end

  defp write_to_logfile(password) do
    {:ok, pid} = PasswordLogger.start_link()
    PasswordLogger.log_incorrect(pid, "wrong_password #{password}")
  end
end
