
# https://github.com/Caterpolaris/aria2list
#
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
# 添加alist nginx(webdav)

FROM caterpolaris/s6alpine

COPY rootfs /

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update && apk add --no-cache curl bash wget unzip nginx jq findutils samba\
    && rm -rf /var/cache/apk/* \
    && mkdir -p /run/nginx && touch /run/nginx/nginx.pid \
    && curl -fsSL ${proxyUrl}https://raw.githubusercontent.com/P3TERX/aria2-builder/master/aria2-install.sh | bash \
    && wget ${proxyUrl}https://github.com/alist-org/alist/releases/download/$(curl -Ls "https://api.github.com/repos/alist-org/alist/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')/alist-linux-musl-amd64.tar.gz \
    && tar -zxvf alist-linux-musl-amd64.tar.gz \
    && mv alist /usr/bin/alist \
    && chmod +x /usr/bin/alist \
    && rm -rf alist-linux-musl-amd64.tar.gz \
    && mkdir /web \
    && ariangVer=`curl -Ls "${proxyUrl}https://api.github.com/repos/mayswind/AriaNg/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'` && wget ${proxyUrl}https://github.com/mayswind/AriaNg/releases/download/${ariangVer}/AriaNg-${ariangVer}-AllInOne.zip \
    && unzip AriaNg-${ariangVer}-AllInOne.zip -d /web \
    && rm -rf AriaNg-${ariangVer}-AllInOne.zip

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=1 \
    RCLONE_CONFIG=/config/rclone/rclone.conf \
    UPDATE_TRACKERS=true \
    CUSTOM_TRACKER_URL=""\
    LISTEN_PORT=6888 \
    RPC_PORT=6800 \
    RPC_SECRET=<TOKEN> \
    PUID=0 \
    PGID=0 \
    DISK_CACHE=64M \
    IPV6_MODE=false \
    UMASK_SET=022 \
    SPECIAL_MODE=""

# 137 138 nmbd
# 139 445 smbd
# 5244 alist
# 6880 ariaNg
# 6800 aria2c rpc
# 6888 aria2c rpc
EXPOSE \
    137/udp \
    138/udp \
    139 \
    445 \
    5244 \
    6880 \
    6800 \
    6888 \
    6888/udp

VOLUME \
    /config \
    /downloads
