defmodule ElixirPidCrtl do
  use GenServer
  require Logger

  @impl true
  def init(%{kp: kp, ki: ki, kd: kd, setpoint: setpoint}) do
    {:ok,
     %{
       output: 0,
       kp: kp,
       ki: ki,
       kd: kd,
       setpoint: setpoint,
       prev_err: 0,
       integral: 0,
       last_update_time: now()
     }}
  end

  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:update, value}, _from, state) do
    new_state = update_controller(value, state)
    {:reply, Map.get(new_state, :output), new_state}
  end

  @impl true
  def handle_call({:tune, %{kp: kp, ki: ki, kd: kd}}, _from, state) do
    new_state = Map.put(state, :kp, kp)
    new_state = Map.put(new_state, :ki, ki)
    new_state = Map.put(new_state, :kd, kd)
    {:reply, :ok, new_state}
  end

  def dump_state(pid) do
    GenServer.call(pid, :state)
  end

  def update(pid, value) do
    GenServer.call(pid, {:update, value})
  end

  def tune(pid, map) do
    GenServer.call(pid, {:tune, map})
  end

  defp update_controller(value, %{
         kp: kp,
         ki: ki,
         kd: kd,
         setpoint: sp,
         prev_err: pe,
         integral: i,
         last_update_time: lut
       }) do
    now = now()
    error = sp - value
    dt = now - lut
    porportional = kp * error
    integral = i + ki * (error * dt)
    derivative = kd * (error - pe) / dt

    %{
      output: porportional + integral + derivative,
      kp: kp,
      ki: ki,
      kd: kd,
      setpoint: sp,
      prev_err: error,
      integral: integral,
      last_update_time: now
    }
  end

  defp now() do
    System.system_time(:second)
  end
end
