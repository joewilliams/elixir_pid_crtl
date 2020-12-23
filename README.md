# ElixirPidCrtl

The dumbest PID controller. I think this mostly works.

Resources:
* https://en.wikipedia.org/wiki/PID_controller
* https://www.wescottdesign.com/articles/pid/pidWithoutAPhd.pdf
* http://www.georgegillard.com/documents/2-introduction-to-pid-controllers

### Run it
```
iex(1)> {:ok, pid} = GenServer.start_link(ElixirPidCrtl, %{kp: 1,ki: 0.1,kd: 0.5,setpoint: 10})
{:ok, #PID<0.141.0>}
iex(2)> ElixirPidCrtl.update(pid, 13)
-4.8
iex(3)> ElixirPidCrtl.update(pid, 13)
-5.1
iex(4)> ElixirPidCrtl.update(pid, 13)
-5.4
iex(5)> ElixirPidCrtl.update(pid, 13)
-6.0
iex(6)> ElixirPidCrtl.dump_state(pid)
%{
  integral: -3.0000000000000004,
  kd: 0.5,
  ki: 0.1,
  kp: 1,
  last_update_time: 1608736579,
  output: -6.0,
  prev_err: -3,
  setpoint: 10
}
```
### Online Tuning
```
iex(8)> ElixirPidCrtl.tune(pid, %{kp: 0.9, ki: 0.2, kd: 0.7})
:ok
iex(9)> ElixirPidCrtl.dump_state(pid)                        
%{
  integral: -7.200000000000001,
  kd: 0.7,
  ki: 0.2,
  kp: 0.9,
  last_update_time: 1608736593,
  output: -10.200000000000001,
  prev_err: -3,
  setpoint: 10
}
```
