defmodule PasswordLogger do
  use GenServer

  # -------------#
  # Client - API #
  # -------------#

  @moduledoc """
  Documentation for Password_logger.
  loggs the password
  """
  @doc """
  Initiate with the given file_logger with file name  .
  """
  def start_link() do
    GenServer.start_link(__MODULE__, "/tmp/password_logs", [])
  end

  def log_incorrect(pid, logtext) do
    GenServer.cast(pid, {:log, logtext})
  end

  ## ---------- ##
  # Server - API #
  ## -----------##

  def init(logfile) do
    # -----------logfile
    {:ok, logfile}
  end

  def handle_cast({:log, logtext}, file_name) do
    File.chmod!(file_name, 0o755)
    {:ok, file} = File.open(file_name, [:append])
    IO.binwrite(file, logtext <> "\n")
    File.close(file)
    {:noreply, file_name}
  end
end
