### Ceph Test 에 필요한 명령어들

### Pool

- pool 생성 : `ceph osd pool create <pool-name> <pg-num> <pgp-num>`
  - `<pool-name>`: 생성할 풀의 이름.
  - `<pg-num>`: 풀에 할당할 PG (Placement Group) 수.
  - `<pgp-num>`: PGP 수 (일반적으로 PG 수와 동일하게 설정)
- pool 초기화 : `rbd pool init <pool-name>`
  - pool 을 rbd 이미지 스토리지에 사용할 수 있도록 초기화
- pool 삭제 : `ceph osd pool delete <pool-name> <pool-name> --yes-i-really-really-mean-it`
-  pool 조회 : `ceph osd pool ls`

### Image

- image 생성 : `rbd create <image-name> --size <size(MB)> --pool <pool-name<`
- image 목록 확인 : `rbd ls <pool name>`

- image 정보 확인 : `rbd info <image-name> --pool <pool-name>`

- image 삭제 : `rbd rm <image-name> --pool <pool-name>`
- image 사용 용량 확인 : `rbd disk-usage <pool-name>/<image-name>`
  ```
  NAME                                         PROVISIONED USED
  csi-vol-c23e3e23-fd69-4276-94a6-2b2ad60abbb8       1 GiB 140 MiB
  ```

### Snapshot

- snapshot 생성 : `rbd snap create <pool-name>/<image-name>@<snapshot-name>`
- snapshot 목록 확인 : `rbd snap ls <pool-name>/<image-name>`
- snapshot 삭제 : `rbd snap rm <pool-name>/<image-name>@<snapshot-name>`
- snapshot 롤백(복구?) : `rbd snap rollback <pool-name>/<image-name>@<snapshot-name>`
- snapshot 보호 : `rbd snap protect <pool-name>/<image-name>@<snapshot-name>`
- snapshot 보호 해제 : `rbd snap unprotect <pool-name>/<image-name>@<snapshot-name>`
- 보호되지 않은 스냅샷 전부 삭제 : `rbd snap purge <pool-name>/<image-name>`

### Export

- export(이미지 내보내기) : `rbd export <pool-name>/<image-name> <export-file>`
- export diff(원본부터 스냅샷 까지) : `rbd export-diff <pool-name>/<image-name>@<snapshot-name>`
- export diff(해당 스냅샷 이후의 변경사항을 추출) : `rbd export-diff <pool-name>/<image-name>@<end-snap> --from-snap <start-snap> <diff-file>`

  - `<pool-name>`: 이미지를 포함하는 풀의 이름.
  - `<image-name>`: 차이를 계산할 이미지의 이름.
  - `<start-snap>`: 시작 스냅샷의 이름.
  - `<end-snap>`: 끝 스냅샷의 이름.
  - `<diff-file>`: 내보낼 차이 파일의 경로와 이름.

### Import

- import(이미지 가져오기) : `rbd import <import-file> <pool-name>/<image-name>`

- import diff(내보낸 diff 파일 가져오기) : `rbd import-diff <diff-file> <pool-name>/<image-name>`

  - `<diff-file>`: 가져올 차이 파일의 경로와 이름.

  - `<pool-name>`: 이미지를 포함하는 풀의 이름.

  - `<image-name>`: 차이를 적용할 이미지의 이름.

### Merge Diff

- merge diff(여러 diff 를 하나로 병합) : `rbd merge-diff --output <merge-diff-file> <diff-file-1> <diff-file-2> ...`

  - `<merged-diff-file>`: 병합된 차이 파일의 경로와 이름.

  - `<diff-file-1>`, `<diff-file-2>`, ...: 병합할 차이 파일들.

  - 만약 여러 개의 diff 파일이 있다면, 쉘 확장(예: `*.bin` 파일 패턴)을 사용하여 병합할 수도 있습니다.

  - 주의사항

    - **병합 순서**: 파일의 병합 순서는 중요합니다. diff 파일들은 시간 순서대로 병합해야 합니다. 예를 들어, `diff1.bin`이 `diff2.bin`보다 먼저 생성된 경우, 병합할 때도 `diff1.bin`이 먼저 와야 합니다.

    - **파일 유효성**: 각 diff 파일이 동일한 RBD 이미지에 대해 생성된 파일이어야 합니다. 다른 이미지에 대한 diff 파일을 병합하려고 하면 데이터 일관성이 깨질 수 있습니다.

    - **백업**: 병합 작업을 하기 전에 원본 diff 파일을 백업하는 것이 좋습니다. 잘못된 병합 작업으로 인해 데이터 손상이 발생할 수 있기 때문입니다.

```
merge-diff first-diff-path second-diff-path merged-diff-path
이미지의 두 개의 연속 증분 diff를 하나의 단일 diff로 병합합니다.
첫 번째 diff의 끝 스냅샷은 두 번째 diff의 시작 스냅샷과 동일해야 합니다.
첫 번째 diff는 stdin의 경우일 수 있고 병합된 diff는 stdout의 경우일 수 있습니다.
이는 'rbd merge-diff first second - | rbd merge-diff - 세 번째 결과'.
이 명령은 현재 stripe_count == 1 인 소스 증분 diff만 지원합니다.
```

### 원격 rbd 명령어 사용

- 원격 ceph 의 conf 파일과 keyring 파일이 있으면 원격으로 rbd 명령이 가능하다.
  - 예를들면 A 에 있는 ceph image 를 B 에서 export 할 수 있다.
- 원격 export 명령어 : `rbd export <원격 pool-name>/<원격 image-name> <export-file> --conf <conf 파일> --keyring <keyring 파일>`
- 다른  rbd 명령어들도 `--conf`, `--keyring`옵션을 주면 실행할 수 있다.