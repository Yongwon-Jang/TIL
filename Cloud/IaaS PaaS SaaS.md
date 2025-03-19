클라우드 서비스 모델은 크게 IaaS, PaaS, SaaS 세 가지로 구분됩니다. 각각의 개념과 특징은 다음과 같습니다.

## IaaS (Infrastructure as a Service)
- **개념**: 클라우드에서 서버, 스토리지, 네트워크 등 기본적인 인프라 자원을 제공하는 서비스입니다[1][2].
- **특징**:
    - 사용자는 제공된 인프라 위에서 운영체제(OS), 미들웨어, 런타임 환경 및 애플리케이션을 직접 관리하고 설치합니다[3][5].
    - 유연성이 높고 사용자가 원하는 대로 인프라를 구성할 수 있지만 관리 책임이 큽니다[2][3].
- **예시**: AWS EC2, 구글 클라우드 플랫폼(GCP)의 Compute Engine 등[2][7].

## PaaS (Platform as a Service)
- **개념**: 애플리케이션 개발과 배포를 위한 플랫폼 환경을 제공하는 서비스입니다. 인프라뿐 아니라 OS, 미들웨어, 런타임 환경까지 제공됩니다[1][2].
- **특징**:
    - 사용자는 인프라나 운영체제 관리 없이 애플리케이션 개발에만 집중할 수 있습니다[2][6].
    - 빠른 개발과 배포가 가능하며 개발 생산성을 높입니다[6][8].
- **예시**: AWS Elastic Beanstalk, Google App Engine, Microsoft Azure App Service 등[6].

## SaaS (Software as a Service)
- **개념**: 완전한 소프트웨어 솔루션을 클라우드에서 제공하는 서비스로, 사용자는 웹 브라우저를 통해 소프트웨어에 접근하여 사용합니다[1][2].
- **특징**:
    - 별도의 설치나 유지보수가 필요 없으며 사용자는 서비스 이용에만 집중할 수 있습니다[3][4].
    - 보안이나 성능 관리 측면에서 사용자의 제어권이 제한됩니다[2].
- **예시**: Google Docs, Gmail, Dropbox, Netflix 등[4][5].

## IaaS vs PaaS vs SaaS 비교표

| 구분 | IaaS | PaaS | SaaS |
|------|------|------|------|
| 제공 범위 | 서버, 스토리지, 네트워크 등 인프라만 제공 | 인프라 + OS, 미들웨어 등 플랫폼까지 제공 | 인프라 + 플랫폼 + 애플리케이션까지 모두 제공 |
| 사용자 관리 영역 | OS, 미들웨어, 런타임 환경 및 애플리케이션 직접 관리 | 애플리케이션만 관리 | 별도의 관리 필요 없음 |
| 유연성 및 제어권 | 높음 (사용자 제어권 큼) | 중간 (개발 환경 내에서만 제어 가능) | 낮음 (제공된 소프트웨어만 이용 가능) |
| 대표 예시 | AWS EC2 | AWS Elastic Beanstalk | Google Docs |

## 이해를 돕기 위한 그림 예시
```
+----------------------+----------------------+----------------------+
|        On-premise    |         IaaS         |        PaaS          |       SaaS           |
+----------------------+----------------------+----------------------+
| 애플리케이션          | 애플리케이션          | 애플리케이션          | 애플리케이션(제공됨)  |
| 데이터               | 데이터               | 데이터               | 데이터(제공됨)        |
| 런타임               | 런타임               | 런타임(제공됨)       | 런타임(제공됨)        |
| 미들웨어             | 미들웨어             | 미들웨어(제공됨)     | 미들웨어(제공됨)      |
| 운영체제(OS)         | 운영체제(OS)         | 운영체제(OS)(제공됨)| 운영체제(OS)(제공됨)  |
| 가상화               | 가상화(제공됨)       | 가상화(제공됨)       | 가상화(제공됨)        |
| 서버                 | 서버(제공됨)         | 서버(제공됨)         | 서버(제공됨)          |
| 스토리지             | 스토리지(제공됨)     | 스토리지(제공됨)     | 스토리지(제공됨)      |
| 네트워킹             | 네트워킹(제공됨)     | 네트워킹(제공됨)     | 네트워킹(제공됨)      |
+----------------------+----------------------+----------------------+

```

위 그림처럼 서비스 모델에 따라 사용자가 관리해야 하는 영역이 달라지며, SaaS로 갈수록 클라우드 공급자가 담당하는 영역이 증가합니다.

Citations:
[1] https://jins-dev.tistory.com/entry/%ED%81%B4%EB%9D%BC%EC%9A%B0%EB%93%9C-%EA%B3%84%EC%B8%B5-%EB%B0%8F-%EC%84%9C%EB%B9%84%EC%8A%A4-%EB%93%A4%EC%97%90-%EB%8C%80%ED%95%9C-%EC%86%8C%EA%B0%9C-IaaS-PaaS-SaaS
[2] https://inside.nhn.com/tech/173
[3] https://hmw0908.tistory.com/81
[4] https://inpa.tistory.com/entry/WEB-%F0%9F%8C%90-%ED%81%B4%EB%9D%BC%EC%9A%B0%EB%93%9C-%EC%BB%B4%ED%93%A8%ED%8C%85-%EA%B0%9C%EB%85%90-%EC%B4%9D%EC%A0%95%EB%A6%AC-IaaS-SaaS-PaaS
[5] https://velog.io/@youngloper77/SaaS-PaaS-IaaS-%ED%81%B4%EB%9D%BC%EC%9A%B0%EB%93%9C-%EC%84%9C%EB%B9%84%EC%8A%A4-%EC%A0%9C%EA%B3%B5-%ED%98%95%ED%83%9C
[6] https://www.ibm.com/kr-ko/think/topics/iaas-paas-saas
[7] https://wannabe-gosu.tistory.com/23
[8] https://velog.io/@euisuk-chung/IT-%ED%81%B4%EB%9D%BC%EC%9A%B0%EB%93%9C-%EC%BB%B4%ED%93%A8%ED%8C%85%EC%9D%98-%EC%84%9C%EB%B9%84%EC%8A%A4-%EB%AA%A8%EB%8D%B8-IaaS-PaaS-SaaS%EC%99%80-%EC%B5%9C%EC%8B%A0-GPUaaS-IQaaS-%EB%B9%84%EA%B5%90

---
Perplexity로부터의 답변: pplx.ai/share