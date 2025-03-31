## Syncthing

### Syncthing Install
```shell
curl -s https://api.github.com/repos/syncthing/syncthing/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | wget -qi -
```

```shell
tar xvf syncthing-linux-amd64*.tar.gz
```

```shell
 sudo cp syncthing-linux-amd64-*/syncthing /usr/bin/
```

```shell
syncthing  --version

syncthing v1.29.3 "Gold Grasshopper" (go1.24.1 linux-amd64) builder@github.syncthing.net 2025-03-07 11:50:33 UTC
```

### 초기화
```shell
syncthing
[start] 2025/03/28 04:05:37 INFO: syncthing v1.29.3 "Gold Grasshopper" (go1.24.1 linux-amd64) builder@github.syncthing.net 2025-03-07 11:50:33 UTC
[start] 2025/03/28 04:05:37 INFO: Generating ECDSA key and certificate for syncthing...
[start] 2025/03/28 04:05:37 INFO: Default folder created and/or linked to new config
[start] 2025/03/28 04:05:37 INFO: Default config saved. Edit /root/.local/state/syncthing/config.xml to taste (with Syncthing stopped) or use the GUI
[start] 2025/03/28 04:05:37 INFO: Archiving a copy of old config file format at: /root/.local/state/syncthing/config.xml.v0
[RKQYF] 2025/03/28 04:05:38 INFO: My ID: RKQYFDU-OPOLTCA-VCZFEN4-5S2CX25-M2K6XK7-VKSCYTO-NJVPW5T-UM7IGQS
[RKQYF] 2025/03/28 04:05:39 INFO: Hashing performance is 80.77 MB/s
[RKQYF] 2025/03/28 04:05:39 INFO: Running database migration 14...
[RKQYF] 2025/03/28 04:05:39 INFO: Running database migration 16...
[RKQYF] 2025/03/28 04:05:39 INFO: Running database migration 17...
[RKQYF] 2025/03/28 04:05:39 INFO: Running database migration 19...
[RKQYF] 2025/03/28 04:05:39 INFO: Running database migration 20...
[RKQYF] 2025/03/28 04:05:39 INFO: Compacting database after migration...
[RKQYF] 2025/03/28 04:05:39 INFO: Overall send rate is unlimited, receive rate is unlimited
[RKQYF] 2025/03/28 04:05:39 INFO: No stored folder metadata for "default"; recalculating
[RKQYF] 2025/03/28 04:05:39 INFO: Using discovery mechanism: global discovery server https://discovery-lookup.syncthing.net/v2/?noannounce
[RKQYF] 2025/03/28 04:05:39 INFO: Using discovery mechanism: global discovery server https://discovery-announce-v4.syncthing.net/v2/?nolookup
[RKQYF] 2025/03/28 04:05:39 INFO: Using discovery mechanism: global discovery server https://discovery-announce-v6.syncthing.net/v2/?nolookup
[RKQYF] 2025/03/28 04:05:39 INFO: Using discovery mechanism: IPv4 local broadcast discovery on port 21027
[RKQYF] 2025/03/28 04:05:39 INFO: Using discovery mechanism: IPv6 local multicast discovery on address [ff12::8384]:21027
[RKQYF] 2025/03/28 04:05:39 INFO: Ready to synchronize "Default Folder" (default) (sendreceive)
[RKQYF] 2025/03/28 04:05:39 INFO: Completed initial scan of sendreceive folder "Default Folder" (default)
[RKQYF] 2025/03/28 04:05:39 INFO: TCP listener ([::]:22000) starting
[RKQYF] 2025/03/28 04:05:39 INFO: Relay listener (dynamic+https://relays.syncthing.net/endpoint) starting
[RKQYF] 2025/03/28 04:05:39 INFO: QUIC listener ([::]:22000) starting
[RKQYF] 2025/03/28 04:05:39 INFO: Loading HTTPS certificate: open /root/.local/state/syncthing/https-cert.pem: no such file or directory
[RKQYF] 2025/03/28 04:05:39 INFO: Creating new HTTPS certificate
[RKQYF] 2025/03/28 04:05:39 INFO: GUI and API listening on 127.0.0.1:8384
[RKQYF] 2025/03/28 04:05:39 INFO: Access the GUI via the following URL: http://127.0.0.1:8384/
[RKQYF] 2025/03/28 04:05:39 INFO: My name is "localhost.localdomain"
[RKQYF] 2025/03/28 04:05:39 WARNING: Syncthing should not run as a privileged or system user. Please consider using a normal user account.
[RKQYF] 2025/03/28 04:06:03 INFO: Failed to acquire [::]:22000/TCP open port on NAT-PMP@192.168.1.254: getting new lease on NAT-PMP@192.168.1.254 (external port 36564 -> internal port 22000): read udp 192.168.3.173:51519->192.168.1.254:5351: recvfrom: connection refused
[RKQYF] 2025/03/28 04:06:03 INFO: Detected 1 NAT service
[RKQYF] 2025/03/28 04:06:05 INFO: Joined relay relay://133.130.102.56:22067

```

```shell
syncthing --device-id
RKQYFDU-OPOLTCA-VCZFEN4-5S2CX25-M2K6XK7-VKSCYTO-NJVPW5T-UM7IGQS
```