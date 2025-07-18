###
 # @Author: Justin
 # @Date: 2025-07-18 09:49:51
 # @filename: 
 # @version: 
 # @Description: 
 # @LastEditTime: 2025-07-18 09:49:52
### 
#!/bin/bash
# 自定义目标节点IP（可通过参数传入）
TARGET_IP="${1:-123.57.178.7}"
TARGET_PORT="${2:-60015}"

# 查询目标 Beacon 节点的身份信息
response=$(curl -s "http://${TARGET_IP}:${TARGET_PORT}/eth/v1/node/identity")

# 检查返回是否为空
if [ -z "$response" ]; then
  echo "❌ 无法从 ${TARGET_IP}:${TARGET_PORT} 获取节点信息。"
  exit 1
fi

# 提取 peer_id 和 p2p_address
peer_id=$(echo "$response" | jq -r '.data.peer_id')
p2p_address=$(echo "$response" | jq -r '.data.p2p_addresses[0]')

# 校验是否成功获取
if [ "$peer_id" == "null" ] || [ -z "$p2p_address" ]; then
  echo "❌ 无法解析节点信息，可能节点未启动或接口异常。"
  exit 1
fi

# 构造 --peer 参数
peer_argument="--peer=${p2p_address}"

# 输出为 docker-compose.yml 段落形式
cat <<EOF

# 节点 ${TARGET_IP}:${TARGET_PORT} 的 Peer 信息
    command:
      - ${peer_argument}

EOF

# 可选：打印提示信息
echo "✅ 已生成 --peer 参数: ${peer_argument}"