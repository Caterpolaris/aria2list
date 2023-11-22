# Aria2List - Aria2 Pro & Aria2NG & alist Docker

Aria2List基于Aria2 Pro 添加 AriaNG 和 alist 的All in one Docker.

## New Features

* 支持alist直接新增本地目录/downloads,达到下载->管理的目标
* 离线Aria2 Pro所有线上脚本,安装时不需在线下载,提高安装速度
* 支持升级aria2,alist,aria2ng,rclone等所有组件

## Usage

### Docker CLI

#### Build image

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
    -v ${pwd}/aria2list:/config \
    -v ${pwd}/aria2_downloads/:/downloads \
    caterpolaris/aria2list:latest
```

## 服务

| 端口   | 功能            |
|------|---------------|
| 5244 | Alist 服务端口    |
| 6880 | Aria2NG 下载界面  |
| 6800 | Aria2 PRC通讯端口 |
| 6888 | BT 监听端口（TCP）  |
| 6888 | DHT 监听端口（UDP） |

## 参数

| 参数                               | 功能                                                                                                         |
|----------------------------------|------------------------------------------------------------------------------------------------------------|
| `-e PUID=$UID`<br>`-e PGID=$GID` | 将 UID 和 GID 绑定到容器中，这意味着您可以使用非 root 用户来管理下载的文件。                                                             |
| `-e UMASK_SET=022`               | 用于设置 Aria2 的 umask 值，可选，默认值为 `022`。                                                                        |
| `-e RPC_SECRET=<TOKEN>`          | 设置 RPC 密钥进行授权验证。默认值为 `P3TERX`。                                                                             |
| `-e RPC_PORT=6800`               | 设置 RPC 监听端口。                                                                                               |
| `-e ALIST_ADMIN_PASSWORD`        | 设置Alist初始密码                                                                                                |
| `-p 6800:6800`                   | 绑定 RPC 监听端口。                                                                                               |
| `-e LISTEN_PORT=6888`            | 设置 BitTorrent/DHT 监听的 TCP/UDP 端口号。                                                                         |
| `-p 6888:6888`                   | 绑定 BT 监听端口（TCP）。                                                                                           |
| `-p 6888:6888/udp`               | 绑定 DHT 监听端口（UDP）。                                                                                          |
| `-v <PATH>:/config`              | 包含所有相关的配置文件。                                                                                               |
| `-v <PATH>:/downloads`           | 下载文件在磁盘上的位置。                                                                                               |
| `-e DISK_CACHE=<SIZE>`           | 设置磁盘缓存大小。SIZE 可以包含 `K` 或 `M`（1K = 1024，1M = 1024K），例如 `64M`。                                               |
| `-e IPV6_MODE=<BOOLEAN>`         | 是否启用 Aria2 的 IPv6 支持。可选：`true` 或 `false`。在配置文件（aria2.conf）中设置选项 `disable-ipv6=false` 和 `enable-dht6=true`。 |
| `-e UPDATE_TRACKERS=<BOOLEAN>`   | 是否自动更新 BT Tracker 列表。可选：`true` 或 `false`，默认值为 `true`。                                                      |
| `-e CUSTOM_TRACKER_URL=<URL>`    | 自定义 BT Tracker 列表的 URL。如果未设置，将从 https://trackerslist.com/all_aria2.txt 获取。                                 |
| `-e TZ=Asia/Shanghai`            | 指定要使用的时区，例如 `Asia/Shanghai`。                                                                               |

## Advanced

### 修改alist 管理密码

```bash
alist admin set 123456 --data /config/alist/
```

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
