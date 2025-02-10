defmodule Counter.Store do
  use GenServer

  def start_link(file) do
    GenServer.start_link(__MODULE__, file, name: __MODULE__)
  end

  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  @impl true
  def init(file) do
    {:ok, file}
  end

  @impl true
  def handle_cast({:put, key, value}, file) do
    m = Map.put(read_file(file), key, value)
    :ok = File.write(file, :erlang.term_to_binary(m))
    {:noreply, file}
  end

  @impl true
  def handle_call({:get, key}, _from, file) do
    value = Map.get(read_file(file), key, 0)
    {:reply, value, file}
  end

  defp read_file(file) do
    case File.read(file) do
      {:ok, content} -> :erlang.binary_to_term(content)
      {:error, _} -> %{}
    end
  end
end

# 이 모듈은 GenServer를 이용한 저장소 서버입니다.
# start_link/1 함수는 파일 경로를 인자로 받아 서버를 시작하며, 등록된 이름(모듈 이름)을 사용합니다.
# put/2와 get/1은 각각 데이터를 저장하고 읽어오는 클라이언트 API 함수입니다.
# init/1에서는 파일 경로를 초기 상태로 저장합니다.
# handle_cast/2에서는 {:put, key, value} 메시지를 받아 파일의 내용을 읽은 후 새로운 값을 추가하여 다시 파일에 기록합니다.
# handle_call/3에서는 {:get, key} 메시지를 받아 파일의 내용을 읽고, 요청한 key의 값을 반환합니다.
# read_file/1 함수는 파일을 읽어 이진 데이터를 Map으로 변환하며, 파일이 없으면 빈 Map을 반환합니다.
