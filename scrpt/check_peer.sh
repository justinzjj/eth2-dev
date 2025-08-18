###
 # @Author: Justin
 # @Date: 2025-07-18 09:49:51
 # @filename: 
 # @version: 
 # @Description: 
 # @LastEditTime: 2025-08-13 08:33:51
### 
#!/bin/bash
# 自定义目标节点IP（可通过参数传入）
ENV_PATH="../.env"
if [ -f "$ENV_PATH" ]; then
  echo "📥 加载环境变量：$ENV_PATH"
  set -o allexport
  source "$ENV_PATH"
  set +o allexport
else
  echo "❌ 未找到环境变量文件：$ENV_PATH"
  exit 1
fi


TARGET_IP="$PUBLIC_IP"
TARGET_PORT="$BEACON_GRPC_PORT"

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
peer_argument_replaced=$(echo "$peer_argument" | sed 's#10\.250\.0\.12/tcp/9000#123.57.178.7/tcp/60016#')
echo "✅ 替换后的 Peer 参数: ${peer_argument_replaced}"