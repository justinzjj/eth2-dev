###
 # @Author: Justin
 # @Date: 2025-07-18 09:50:19
 # @filename: 
 # @version: 
 # @Description: 
 # @LastEditTime: 2025-07-18 09:50:20
### 

#!/bin/bash

# 查询本地 Beacon 节点身份信息
response=$(curl -s http://127.0.0.1:60015/eth/v1/node/identity)

# 提取 peer_id
peer_id=$(echo "$response" | jq -r '.data.peer_id')

# 提取 p2p 地址（仅取第一个）
p2p_address=$(echo "$response" | jq -r '.data.p2p_addresses[0]')

# 构造 --peer= 参数
peer_argument="--peer=${p2p_address}"

# 显示结果
echo "✅ Peer ID: $peer_id"
echo "✅ P2P Address: $p2p_address"
echo "✅ 启动参数:"
echo "$peer_argument"