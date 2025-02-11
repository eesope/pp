1. TCP 소켓 통신 및 옵션 설정

* TCP 연결 수립:
:gen_tcp.connect/3와 :gen_tcp.listen/3를 사용하여 클라이언트와 서버 간에 TCP 연결을 생성합니다.

* 소켓 옵션 설정: 옵션으로 
:binary (바이너리 데이터 처리),
packet: :line (한 줄 단위의 패킷 처리),
active: true|false|:once (소켓이 메시지를 자동으로 수신할지, 수동으로 읽을지 또는 한 번만 수신할지) 등을 사용

* reuseaddr: true:
포트 재사용 옵션으로, 서버를 재시작할 때 “Address already in use” 오류를 방지




