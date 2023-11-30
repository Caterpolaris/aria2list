# Aria2List - Aria2 Pro & Aria2NG & alist Docker

Aria2List基于Aria2 Pro 添加 AriaNG、alist、samba 的All in one Docker.

## New Features

* 支持alist直接新增本地目录/downloads,达到下载->管理的目标
* 离线Aria2 Pro所有线上脚本,安装时不需在线下载,提高安装速度
* 支持升级aria2,alist,aria2ng,rclone等所有组件
* 升级apline到3.14.2
* 增加samba共享服务,方便管理下载文件
* 修改samba配置保存密钥到文件,避免每次升级docker都需要输入密码

## Usage

### Docker CLI

#### Build image
```bash
docker build -t caterpolaris/aria2list:latest  --progress=plain .
```

#### Run image
```bash
docker run -d \
    --name aria2list \
    --restart unless-stopped \
    --log-opt max-size=1m \
    --network host \
    -e PUID=$UID \
    -e PGID=$GID \
    -e RPC_SECRET=<token> \
    -e RPC_PORT=6800 \
    -e LISTEN_PORT=6888 \
    -e ALIST_ADMIN_PASSWORD=password \
    -e SMB_USERNAME=smbuser \
    -e SMB_PASSWORD=smbpassword \
    -v ${pwd}/aria2list_config:/config \
    -v ${pwd}/aria2_downloads/:/downloads \
    caterpolaris/aria2list:latest
```

## 配置

### 修改alist 管理密码

```bash
docker exec -it aria2list alist admin set password --data /config/alist/
```

### 修改smb密码

```bash
docker exec -it aria2list smbpasswd  smbuser
```
### 添加smb用户

```bash
docker exec -it aria2list smbadduser  user1 password
```

### 配置smb共享目录

手工修改配置文件 `/config/samba/smb.conf`,配置文件参考 [samba](https://wiki.samba.org/index.php/Setting_up_Samba_as_a_Standalone_Server)

### 配置文件
所有服务配置在`${pwd}/aria2list_config:/config`,如需其他高级配置,请自行修改配置文件,修改后重启docker生效.

首次启动docker会自动创建默认配置文件.

## 服务

| 端口      | 功能            |
|---------|---------------|
| 5244    | Alist 服务端口    |
| 6880    | Aria2NG 下载界面  |
| 6800    | Aria2 PRC通讯端口 |
| 6888    | BT 监听端口（TCP）  |
| 6888    | DHT 监听端口（UDP） |
| 445,139 | smb服务         |

## 参数

| 参数                               | 功能                                                                                                        |
|----------------------------------|-----------------------------------------------------------------------------------------------------------|
| `-e PUID=$UID`<br>`-e PGID=$GID` | 将 UID 和 GID 绑定到容器中，这意味着您可以使用非 root 用户来管理下载的文件                                                             |
| `-e UMASK_SET=022`               | 用于设置 Aria2 的 umask 值，可选，默认值为 `022`                                                                        |
| `-e RPC_SECRET=<TOKEN>`          | 设置 RPC 密钥进行授权验证。默认值为 `P3TERX`                                                                             |
| `-e RPC_PORT=6800`               | 设置 RPC 监听端口                                                                                               |
| `-e ALIST_ADMIN_PASSWORD`        | 设置Alist初始密码                                                                                               |
| `-e SMB_USERNAME`                | 设置smb用户名,默认值为 `smbuser`                                                                                   |
| `-e SMB_PASSWORD`                  | 设置smb密码,默认值为 `smbpassword`                                                                                |
| `-p 6800:6800`                   | 绑定 RPC 监听端口。                                                                                              |
| `-e LISTEN_PORT=6888`            | 设置 BitTorrent/DHT 监听的 TCP/UDP 端口号                                                                         |
| `-p 6888:6888`                   | 绑定 BT 监听端口（TCP）                                                                                           |
| `-p 6888:6888/udp`               | 绑定 DHT 监听端口（UDP）                                                                                          |
| `-v <PATH>:/config`              | 包含所有相关的配置文件                                                                                               |
| `-v <PATH>:/downloads`           | 下载文件在磁盘上的位置                                                                                               |
| `-e DISK_CACHE=<SIZE>`           | 设置磁盘缓存大小。SIZE 可以包含 `K` 或 `M`（1K = 1024，1M = 1024K），例如 `64M`                                               |
| `-e IPV6_MODE=<BOOLEAN>`         | 是否启用 Aria2 的 IPv6 支持。可选：`true` 或 `false`。在配置文件（aria2.conf）中设置选项 `disable-ipv6=false` 和 `enable-dht6=true` |
| `-e UPDATE_TRACKERS=<BOOLEAN>`   | 是否自动更新 BT Tracker 列表。可选：`true` 或 `false`，默认值为 `true`                                                      |
| `-e CUSTOM_TRACKER_URL=<URL>`    | 自定义 BT Tracker 列表的 URL。如果未设置，将从 https://trackerslist.com/all_aria2.txt 获取                                 |
| `-e TZ=Asia/Shanghai`            | 指定要使用的时区，例如 `Asia/Shanghai`                                                                               |



## Credits

* [alist](https://github.com/alist-org/alist)
* [AriaNg]( https://github.com/mayswind/AriaNg)
* [aria2](https://github.com/aria2/aria2)
* [P3TERX/aria2.conf](https://github.com/P3TERX/aria2.conf)
* [P3TERX/Aria2-Pro-Core](https://github.com/P3TERX/Aria2-Pro-Core)
* [just-containers/s6-overlay](https://github.com/just-containers/s6-overlay)
* [XIU2/TrackersListCollection](https://github.com/XIU2/TrackersListCollection)

## License

[MIT](https://github.com/caterpolaris/aria2list/blob/master/LICENSE) © caterpolaris
