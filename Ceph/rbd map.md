## rbd map
> RBD 이미지를 블록 디바이스로 매핑한 다음 파일 시스템으로 마운트하여 데이터를 확인할 수 있습니다.

### RBD 이미지 마운트
1. rbd image 매핑 : `rbd map <pool-name>/<image-name>`
   ```
      ex) # rbd map yw/csi-vol-c23e3e23-fd69-4276-94a6-2b2ad60abbb8
            /dev/rbd0
   ```
2. 파일 시스템 마운트 : `mount /dev/rbd0 /mnt`
   - RBD 이미지에 파일시스템이 존재하면 마운트 할 수 있다.

3. 마운트된 디렉토리에서 데이터 확인

### RBD 이미지 마운트 해제
- 마운트된 경로 해제 : `umount /mnt`
- 매핑된 이미지 확인 : `rbd device list`
- 매핑 해제 : `rbd unmap /dev/rbdX`

#### 파일시스템 만들기
- `mkfs.ext4 /dev/rbd0`
#### map 안될때
- `rbd feature disable yw/test object-map fast-diff deep-flatten`