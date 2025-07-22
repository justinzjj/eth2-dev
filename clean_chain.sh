###
 # @Author: Justin
 # @Date: 2025-07-17 04:36:58
 # @filename: 
 # @version: 
 # @Description: 
 # @LastEditTime: 2025-07-22 06:38:37
### 
#!/bin/bash

# 删除指定容器（如果存在）
for container in eth2-dev-multi-beacon-chain-1 eth2-dev-multi-geth-1 eth2-dev-multi-validator-1; do
  if docker ps -a --format '{{.Names}}' | grep -q "^${container}$"; then
    echo "🗑️ 正在删除容器: $container"w
    docker rm -f "$container"
  else
    echo "⚠️ 容器不存在: $container"
  fi
done
#  移除网络
docker compose down --remove-orphans
docker network prune

# 清理数据
docker compose run --rm root-change
rm -Rf ./consensus/beacondata ./consensus/validatordata ./consensus/genesis.ssz
rm -Rf ./execution/geth
rm -Rf ./execution/geth.ipc
echo "🚀 清理完成！"