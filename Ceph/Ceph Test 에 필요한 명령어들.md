### Ceph Test 에 필요한 명령어들

### Pool

- pool 생성 : `ceph osd pool create <pool-name> <pg-num> <pgp-num>`
  - `<pool-name>`: 생성할 풀의 이름.
  - `<pg-num>`: 풀에 할당할 PG (Placement Group) 수.
  - `<pgp-num>`: PGP 수 (일반적으로 PG 수와 동일하게 설정)
- pool 삭제 : `ceph osd delete <pool-name> <pool-name> --yes-i-really-really-mean-it`
-  pool 조회 : `ceph osd pool ls`

### Image

- image 생성 : `rbd create <image-name> --size <size(MB)> --pool <pool-name<`
- image 목록 확인 : `rbd ls <pool name>`

- image 정보 확인 : `rbd info <image-name> --pool <pool-name>`

- image 삭제 : `rbd rm <image-name> --pool <pool-name>`

### Snapshot

- snapshot 생성 : `rbd snap create <pool-name>/<image-name>@<snapshot-name>`
- snapshot 목록 확인 : `rbd snap ls <pool-name>/<image-name>`
- snapshot 삭제 : `rbd snap rm <pool-name>/<image-name>@<snapshot-name>`
- snapshot 롤백(복구?) : `rbd snap rollback <pool-name>/<image-name>@<snapshot-name>`
- snapshot 보호 : `rbd snap protect <pool-name>/<image-name>@<snapshot-name>`
- snapshot 보호 해제 : `rbd snap unprotect <pool-name>/<image-name>@<snapshot-name>`

### Export

- export(이미지 내보내기) : `rbd export <pool-name>/<image-name> <export-file>`

- export diff(두 스냅샷 차이 내보내기) : `rbd export-diff <pool-name>/<image-name> --from-snap <start-snap> --to-snap <end-snap> <diff-file>`

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

