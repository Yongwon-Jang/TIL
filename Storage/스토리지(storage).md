## 스토리지(storage)

### 스토리지란?

- 컴퓨터가 접근할 수 있는 데이터를 저장하기 위한 별도의 장소 또는 장치
- DAS, NAS, SAN 으로 구분할 수 있음



### DAS

- Direct Attachted Storage
- 저장 장치가 직접 개별 호스트에 연결되어 사용 및 관리되는 방식
- 장점
  - 각 호스트에서 저장 장치까지 물리적으로 가까운 곳에서 접근 가능
  - 확장이 비교적 쉬움
- 단점
  - 특성상 완전히 고립된 정보 저장소 일 수 밖에 없다.
  - 데이터나 여유 리소스를 다른 서버와 독립적으로 공유할 수 없다.
  - 물리적인 공간이 한계에 봉착 했을 때 확장이 어려움

![das](images/das.PNG)

### NAS

- Network Attached Storage

- 컴퓨터 네트워크에 연결된 파일 수준의 컴퓨터 기억 장치이며 서로 다른 네트워크 클라이언트에 데이터 접근 권한을 제공
- 장점
  - LAN을 연결하여 사용하기 때문에 비용이 저렴하다.
  - 여러 다른 장치들의 데이터 저장/읽기에 용이
  - PORT수 제한이 없어 확장성과 유연성이 뛰어남
    - 설치 및 유지보수 용이
- 단점
  - 네트워크의 병목 현상에 취약
  - 접속 증가시 성능저하, 전송속도 DAS보다 느림
  - 파일시스템을 공유하기 때문에 보안에 비교적 취약
- NAS의 주요 프로토콜
  - NFS
  - SMB/CIFS
  - FTP
  - HTTP
  - AFP

![nas](images/nas.PNG)

### SAN

- Storage Area Network
- 여러 스토리지들을 하나의 네트워크에 연결시킨 다음 이 네트워크를 스토리지 전용 네트워크로 구성을 하는 방식
- 일명 저장지역통신망
- 별도의 SAN 전용 스위치가 필요
  - 광 케이블로 통신하는 FC-SAN방식
    - 10km 이내의 구성시 사용 가능
  - IP-SAN 방식
    - 기본 IP 통신이 가능한 범위라면 거리 제한 없음
- 장점
  - 성능 및 용량 확장성이 좋음
  - 가강화 환경을 구축하기 좋음
- 단점
  - 구성에 따라 네트워크 복잡도가 높아짐
  - 상대적으로 비싸며 관리 포인트가 많아짐
- SAN의 주요 스토리지 프로토콜
  - FC
  - FCIP
  - iSCSI
  - iSER

![san](images/san.PNG)



### Scale Up 방식

- 기존의 서버를 보다 높은 사양으로 업그레이드 하는 것. 예를 들면, 성능이나 용량 증가를 목적으로 하나의 서버에 디스크를 추가하거나 CPU, 메모리를 업그레이드 시키는것

### Scale Out 방식

- 장비를 추가해서 확장하는 방식
- 기존 서버만으로 한계에 도달했을 때, 비슷한 사양의 서버를 추가로 연결해 처리할 수 있는 데이터 용량을 증가시키고 기존 서버의 부하를 분담한다.

#### Scale Up vs Scale Out

![scale](images/scale.PNG)



- 참고
  - https://tecoble.techcourse.co.kr/post/2021-10-12-scale-up-scale-out/
