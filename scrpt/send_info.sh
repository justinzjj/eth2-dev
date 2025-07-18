###
 # @Author: Justin
 # @Date: 2025-07-18 09:50:03
 # @filename: 
 # @version: 
 # @Description: 
 # @LastEditTime: 2025-07-18 09:50:04
### 
#!/bin/bash

docker compose up root-change
# 服务器列表
servers=(
    "47.105.72.183"
    "47.105.78.150"
    "39.99.37.87"
    "39.99.41.202"
)
# 发送到远程服务器
for server in "${servers[@]}"; do
    sshpass -p 'ethereum' scp ../execution/genesis.json ethereum@"$server":~/workSpace/Ethereum/eth2-dev-multi/execution/
    sshpass -p 'ethereum' scp ../consensus/genesis.ssz ethereum@"$server":~/workSpace/Ethereum/eth2-dev-multi/consensus/
done


 sshpass -p 'ethereum' scp workSpace.tar.gz ethereum@47.105.72.183:~/
 sshpass -p 'ethereum' scp workSpace.tar.gz ethereum@47.105.78.150:~/
 sshpass -p 'ethereum' scp workSpace.tar.gz ethereum@39.99.37.87:~/
 sshpass -p 'ethereum' scp workSpace.tar.gz ethereum@39.99.41.202:~/

