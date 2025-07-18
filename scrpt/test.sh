###
 # @Author: Justin
 # @Date: 2025-07-18 10:00:33
 # @filename: 
 # @version: 
 # @Description: 
 # @LastEditTime: 2025-07-18 10:03:09
### 
# 这个脚本只有一些 用于测试的命令 不能直接执行

docker compose up create-beacon-chain-genesis
docker compose up geth-remove-db
docker compose up geth-genesis
docker compose up root-change
docker compose up beacon-chain
docker compose up geth
docker compose up validator


docker exec -it eth2-dev-multi-geth-1 /bin/sh
cd /execution && geth attach geth.ipc

docker exec -it eth2-dev-multi-beacon-node1-1 /bin/bash 

> admin.peers
> net.peerCount
> net.listening
> admin.addPeer
> admin.nodeInfo
> eth.blockNumber
> eth.syncing
> admin.peers

telnet 47.105.72.183 60013



