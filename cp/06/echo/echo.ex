defmodule ActiveEchoServer do
  require Logger

  def start(port \\ 1234) do
    {:ok, lsocket} = :gen_tcp.listen(port,
      [:binary, active: true, packet: :line, reuseaddr: true])
    accept(lsocket)
  end

  defp accept(lsocket) do  # listening socket
    {:ok, socket} = :gen_tcp.accept(lsocket)
    spawn(fn -> accept(lsocket) end)
    Logger.info("#{inspect self()} connection established: #{inspect socket}")
    loop(socket)
  end

  # 소켓을 active mode로 설정하면,
  # 데이터 수신이 자동으로 프로세스 메시지로 전달되어 receive 구문으로 처리 가능
  defp loop(socket) do
    receive do
      {:tcp, ^socket, data} ->
        :gen_tcp.send(socket, data)
        loop(socket)
      {:tcp_closed, ^socket} ->
        Logger.info("#{inspect self()} connection closed: #{inspect socket}")
        :gen_tcp.close(socket)
    end
  end
end

defmodule PassiveEchoServer do
  require Logger

  def start(port \\ 1234) do
    {:ok, lsocket} = :gen_tcp.listen(port,
      [:binary, active: false, packet: :line, reuseaddr: true])
    accept(lsocket)
  end

  defp accept(lsocket) do
    {:ok, socket} = :gen_tcp.accept(lsocket)
    spawn(fn -> accept(lsocket) end)
    Logger.info("#{inspect self()} connection established: #{inspect socket}")
    loop(socket)
  end

  # passive mode에서는 프로세스가 직접 recv 호출을 통해 데이터를 읽어야 하며,
  # 이는 메시지 패싱 없이 동기적으로 처리

  defp loop(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        :gen_tcp.send(socket, data)
        loop(socket)
      {:error, :closed} ->
        Logger.info("#{inspect self()} connection closed: #{inspect socket}")
        :gen_tcp.close(socket)
    end
  end
end

defmodule HybridEchoServer do
  require Logger

  def start(port \\ 1234) do
    {:ok, lsocket} = :gen_tcp.listen(port,
      [:binary, active: false, packet: :line, reuseaddr: true])
    accept(lsocket)
  end

  defp accept(lsocket) do
    {:ok, socket} = :gen_tcp.accept(lsocket)
    spawn(fn -> accept(lsocket) end)
    Logger.info("#{inspect self()} connection established: #{inspect socket}")
    loop(socket)
  end

  # 기본적으로 수동 모드로 동작
  # 필요할 때 active: :once를 설정
  # -> 한 번만 자동 메시지 수신을 처리
  # -> 다시 passive 상태로 돌아감
  # 이로써 과도한 메시지 폭주를 피하면서도, 이벤트 기반의 반응형 처리 가능

  defp loop(socket) do
    :inet.setopts(socket, active: :once)
    receive do
      {:tcp, ^socket, data} ->
        :gen_tcp.send(socket, data)
        loop(socket)
      {:tcp_closed, ^socket} ->
        Logger.info("#{inspect self()} connection closed: #{inspect socket}")
        :gen_tcp.close(socket)
    end
  end
end
