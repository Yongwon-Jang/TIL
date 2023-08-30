###  MariaDB 데이터 복제 하는법

> `/var/lib/mysql`  디렉터리는 MariaDB 데이터 디렉터리로 사용되며, 데이터베이스와 테이블 데이터가 저장되는 위치이다. 따라서 `/var/lib/mysql` 디렉터리를 복사하여 새로운 노드에 복제하고 해당 디렉터리를 사용하여 데이터베이스와 테이블을 복구할 수 있다.

1. 기존 노드의 `/var/lib/mysql` 경로를 복사해서 새 노드로 옮긴다.

```
[기존 노드]
# cp -r /var/lib/mysql /path/to/backup

# scp -r /path/to/backup user@new_node:/path/to/destination
```

2. 새 노드에서 `/var/lib/mysql` 디렉토리로 이동하여 데이터베이스를 복구하고, MariaDB 중지 후 기존 노드에서 받은 디렉터리를 `/var/lib/mysql` 로 옮긴다.

```
# MariaDB 서비스 중지
systemctl stop mariadb

# 기존의 /var/lib/mysql 디렉터리 백업
mv /var/lib/mysql /var/lib/mysql_backup

# 복제된 디렉터리로 이동
mv /path/to/destination /var/lib/mysql

# 소유권과 권한 설정
chown -R mysql:mysql /var/lib/mysql

# MariaDB 서비스 시작
systemctl start mariadb
```

이렇게 하면 새로운 노드에 기존 노드의 데이터베이스와 테이블이 복구됩니다. 

#### 주의

 `/var/lib/mysql` 디렉터리를 복제하고 이동할 때 MariaDB 서비스를 중지해야 하며, 권한과 소유권을 올바르게 설정해야 한다.