## Image Mirror
  - `rbd mirror pool enable <pool-name> <mode>` : mirroring 활성화
    - `<mode>` 가 `pool` 이면 pool 내 모든 이미지 미러링
    - `<mode>` 가 `image` 이면 개별 이미지 미러링
  - `rbd feature enable <pool-name>/<image-name> exclusive-lock` : RBD image 에서 저널링을 사용할 수 있도록 하는 기능
  - `rbd feature enable <pool-name>/<image-name> journaling` : 저널링 활성화, 미러링전 필요
  - `rbd mirror image enable <pool-name>/<image-name>` : 미러링 활성화
  - `rbd mirror image status <pool-name>/<image-name>` : 미러링 상태 확인

