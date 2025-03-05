1. TCP 소켓 통신 및 옵션 설정

* TCP 연결 수립:
:gen_tcp.connect/3와 :gen_tcp.listen/3를 사용하여 클라이언트와 서버 간에 TCP 연결을 생성합니다.

* 소켓 옵션 설정: 옵션으로 
:binary (바이너리 데이터 처리),
packet: :line (한 줄 단위의 패킷 처리),
active: true|false|:once (소켓이 메시지를 자동으로 수신할지, 수동으로 읽을지 또는 한 번만 수신할지) 등을 사용

* reuseaddr: true:
포트 재사용 옵션으로, 서버를 재시작할 때 “Address already in use” 오류를 방지

이 샘플 코드는 TCP 네트워킹을 다루는 예제로, Elixir/Erlang의 `:gen_tcp` 모듈을 이용하여 에코(echo) 클라이언트와 여러 가지 방식의 에코 서버(active, passive, hybrid)를 구현한 코드입니다.  

---

## 1. TCP 소켓 통신 및 옵션 설정

- **TCP 연결 수립:**  
  `:gen_tcp.connect/3`와 `:gen_tcp.listen/3`를 사용하여 클라이언트와 서버 간에 TCP 연결을 생성합니다.  
- **소켓 옵션 설정:**  
  옵션으로 `:binary` (바이너리 데이터 처리),  
  `packet: :line` (한 줄 단위의 패킷 처리),  
  `active: true|false|:once` (소켓이 메시지를 자동으로 수신할지, 수동으로 읽을지 또는 한 번만 수신할지) 등을 사용합니다.  
- **reuseaddr: true:**  
  포트 재사용 옵션으로, 서버를 재시작할 때 “Address already in use” 오류를 방지합니다.

---

## 2. 에코 클라이언트 (EchoClient)

```elixir
defmodule EchoClient do
  def connect(host, port) do
    {:ok, socket} = :gen_tcp.connect(host, port,
      [:binary, active: false, packet: :line])
    loop(socket)
  end
  ...
end
```

- **클라이언트 역할:**  
  - 주어진 호스트와 포트로 TCP 연결을 생성합니다.
  - 옵션 `active: false`로 설정하여 소켓을 수동 모드(passive mode)로 사용합니다.
- **루프(loop) 함수:**  
  - 사용자로부터 입력을 받는다 (`IO.gets("> ")`).
  - 입력 데이터가 있으면 서버로 전송하고, `:gen_tcp.recv/2`로 응답을 받아 출력합니다.
  - 입력이 EOF이면 소켓을 닫습니다.

> **핵심 개념:**  
> 클라이언트가 TCP 서버와 연결을 맺고, 데이터를 주고받으며 에코 응답을 확인하는 과정을 보여줍니다.  
> 이 때, 수동 모드(passive)를 사용하여 직접 `recv`를 호출하는 방식을 사용합니다.

---

## 3. Active Echo Server

```elixir
defmodule ActiveEchoServer do
  require Logger

  def start(port \\ 1234) do
    {:ok, lsocket} = :gen_tcp.listen(port,
      [:binary, active: true, packet: :line, reuseaddr: true])
    accept(lsocket)
  end
  ...
end
```

- **서버 시작:**  
  - `:gen_tcp.listen/3`로 서버 소켓을 생성합니다.
  - 옵션 `active: true`를 사용하므로, 각 연결 소켓이 데이터를 수신할 때마다 프로세스에 메시지가 자동으로 전달됩니다.
- **accept 함수:**  
  - `:gen_tcp.accept/1`을 호출해 클라이언트의 연결을 기다립니다.
  - 새 연결이 들어오면 별도의 프로세스(spawn)를 만들어 계속해서 다른 연결을 수락합니다.
  - 연결이 수립되면 로깅(Logger.info) 후, `loop/1` 함수에서 메시지를 대기합니다.
- **loop 함수:**  
  - `receive` 블록으로 소켓에서 자동으로 전달된 메시지를 패턴 매칭합니다.
  - 메시지가 `{ :tcp, socket, data }` 형태이면, 받은 데이터를 그대로 다시 전송(echo)합니다.
  - `{ :tcp_closed, socket }` 메시지를 받으면 연결이 종료된 것으로 판단하고 소켓을 닫습니다.

> **핵심 개념:**  
> 소켓을 **active mode**로 설정하면, 데이터 수신이 자동으로 프로세스 메시지로 전달되어 `receive` 구문으로 처리할 수 있음을 보여줍니다.

---

## 4. Passive Echo Server

```elixir
defmodule PassiveEchoServer do
  require Logger

  def start(port \\ 1234) do
    {:ok, lsocket} = :gen_tcp.listen(port,
      [:binary, active: false, packet: :line, reuseaddr: true])
    accept(lsocket)
  end
  ...
end
```

- **서버 시작:**  
  - `active: false`로 설정하여, 데이터 수신 시 프로세스에 메시지가 자동 전달되지 않고  
    직접 `:gen_tcp.recv/2`를 호출해야 합니다.
- **accept 함수:**  
  - 클라이언트 연결을 수락하고, 별도의 프로세스에서 계속 수락하도록 합니다.
  - 로깅 후 `loop/1` 함수로 제어를 넘깁니다.
- **loop 함수:**  
  - `:gen_tcp.recv(socket, 0)`을 호출해 수동으로 데이터를 기다립니다.
  - 데이터를 수신하면 echo 응답을 보내고 다시 `recv`를 호출합니다.
  - 연결 종료 오류 `{:error, :closed}`가 발생하면 소켓을 닫습니다.

> **핵심 개념:**  
> **passive mode**에서는 프로세스가 직접 `recv` 호출을 통해 데이터를 읽어야 하며, 이는 메시지 패싱 없이 동기적으로 처리됩니다.

---

## 5. Hybrid Echo Server

```elixir
defmodule HybridEchoServer do
  require Logger

  def start(port \\ 1234) do
    {:ok, lsocket} = :gen_tcp.listen(port,
      [:binary, active: false, packet: :line, reuseaddr: true])
    accept(lsocket)
  end
  ...
end
```

- **서버 시작:**  
  - 기본적으로 소켓을 passive 모드로 열지만, 이후에 옵션을 변경할 수 있도록 설정합니다.
- **loop 함수:**  
  - `:inet.setopts(socket, active: :once)`를 호출하여 한 번만 활성(active)으로 전환합니다.
  - 그 후, `receive` 블록에서 `{ :tcp, socket, data }` 메시지를 기다립니다.
  - 데이터를 받으면 echo 응답을 보내고, 다시 `loop`를 호출하여 같은 방식으로 active :once를 설정합니다.
  - `{ :tcp_closed, socket }` 메시지 발생 시 연결 종료 처리 후 소켓을 닫습니다.

> **핵심 개념:**  
> **hybrid mode**(또는 일회성 active 모드)는 passive 모드와 active 모드의 장점을 결합한 방식입니다.  
> - 기본적으로 수동 모드로 동작하지만, 필요할 때 `active: :once`를 설정하여 한 번만 자동 메시지 수신을 처리하고 다시 passive 상태로 돌아갈 수 있습니다.
> - 이를 통해 과도한 메시지 폭주를 피하면서도, 이벤트 기반의 반응형 처리를 할 수 있습니다.

---

## 전체 요약

- **핵심 내용:**  
  이 코드는 TCP 소켓을 이용한 간단한 에코(echo) 시스템을 구현하여,  
  클라이언트와 서버 간의 기본 데이터 송수신 방식을 보여줍니다.

- **다루는 개념:**  
  1. **TCP 네트워킹:**  
     - :gen_tcp 모듈을 이용한 TCP 연결, 수신, 전송.
  2. **소켓 모드:**  
     - **Active mode:** 데이터가 도착하면 자동으로 프로세스 메시지로 전달됨.
     - **Passive mode:** 데이터 수신을 위해 직접 `:gen_tcp.recv/2` 호출.
     - **Hybrid mode:** `active: :once` 옵션을 사용해 한 번만 자동 메시지를 받고 이후 다시 passive 상태로 돌아감.
  3. **동시성 처리:**  
     - 각 연결마다 별도의 프로세스를 생성(`spawn`)하여 다중 클라이언트의 동시 연결을 처리.
  4. **패턴 매칭과 메시지 처리:**  
     - `receive` 구문과 `case` 문을 사용해 연결 종료, 데이터 수신 등 이벤트를 처리.
  5. **환경 설정 및 인자 처리:**  
     - `with` 구문을 사용해 커맨드라인 인자에서 호스트와 포트를 읽어 클라이언트 연결에 활용.
  6. **로깅:**  
     - Logger 모듈을 통해 연결 수립 및 종료 등의 상태를 기록.

이 예제는 TCP 통신의 다양한 모드를 경험해보고, 분산 환경에서의 네트워킹 기초와 동시성 처리, 그리고 에러 처리 및 로깅까지 다루고 있어 네트워크 프로그래밍의 여러 중요한 개념들을 학습할 수 있도록 구성되어 있습니다.

---

소켓은 단순한 데이터나 포트 번호가 아니라, 운영체제에서 관리하는 **네트워크 연결의 끝점(endpoint)** 을 나타내는 추상적인 리소스입니다.

구체적으로 설명하면:

1. **lsocket과 socket의 차이:**  
   - `lsocket`은 서버가 클라이언트의 연결 요청을 기다리는 **리스닝 소켓(listening socket)** 입니다.  
   - `:gen_tcp.accept(lsocket)`를 호출하면, 새로운 클라이언트의 연결이 수락되고, 이때 반환되는 `socket`은 **새로운 연결**에 대한 **소켓 핸들**입니다.  
     즉, 이 `socket`은 클라이언트와 서버 사이의 개별 통신 채널을 나타내며, 데이터를 송수신하는 데 사용됩니다.

2. **소켓의 개념:**  
   - 소켓은 네트워크 통신을 위한 인터페이스로, 운영체제에서 관리하는 리소스입니다.  
   - 실제로 소켓은 파일 디스크립터(file descriptor)와 유사하며, 이를 통해 읽기/쓰기 작업이 이루어집니다.
   - 소켓은 연결된 양측(클라이언트와 서버)에서 **데이터를 주고받기 위한 통신 경로**를 제공하며, 메시지 또는 스트림 데이터를 전송할 수 있습니다.

따라서,  
- `{:ok, socket} = :gen_tcp.accept(lsocket)`에서 반환되는 `socket`은 새로 연결된 클라이언트와의 통신을 위해 생성된 소켓입니다.  
- 이 소켓은 단순한 데이터가 아니라, 네트워크 연결의 **활성화된 통신 채널** (즉, 연결의 끝점)입니다.  
- 이를 통해 서버는 클라이언트와 개별적으로 데이터를 주고받을 수 있습니다.