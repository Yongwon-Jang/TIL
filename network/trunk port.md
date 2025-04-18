# Trunk Port
트렁크 포트(Trunk Port)는 네트워크 스위치에서 여러 VLAN(Virtual LAN)의 트래픽을 동시에 전달할 수 있도록 설정된 포트입니다. 트렁크 포트를 통해 서로 다른 VLAN에 속한 데이터 패킷들이 스위치 간에 이동할 수 있게 되어, 여러 VLAN을 단일 링크로 연결할 수 있습니다.

### 트렁크 포트의 주요 특징

1. **다중 VLAN 트래픽 지원**:  
   트렁크 포트는 하나의 링크로 여러 VLAN 트래픽을 전달할 수 있습니다. 이는 대규모 네트워크에서 스위치 간 연결을 최적화할 때 유용합니다.

2. **VLAN 태그 사용**:  
   트렁크 포트는 IEEE 802.1Q 표준을 사용하여 각 데이터 패킷에 VLAN 태그를 추가합니다. 이 태그를 통해 수신 스위치가 해당 트래픽이 어떤 VLAN에 속하는지 식별할 수 있습니다.

3. **액세스 포트와의 차이**:  
   일반적으로 액세스 포트는 단일 VLAN에만 연결되는 포트이며, 트렁크 포트는 여러 VLAN을 지원하여 스위치 간 또는 스위치와 라우터 간에 연결하는 데 사용됩니다.

### 트렁크 포트의 용도

- **스위치 간 VLAN 트래픽 전달**: 여러 VLAN의 트래픽을 전달하여, 다양한 VLAN 간 통신을 위해 다수의 물리적 케이블이 필요하지 않도록 합니다.
- **VLAN 간 라우팅**: 트렁크 포트를 통해 라우터 또는 레이어 3 스위치에 연결하면 VLAN 간 트래픽을 라우팅할 수 있습니다.

트렁크 포트는 스위치 기반 네트워크를 VLAN으로 분리하여 더욱 유연하게 구성하고 관리할 수 있도록 도와줍니다.