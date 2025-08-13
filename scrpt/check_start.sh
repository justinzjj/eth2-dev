###
 # @Author: Justin
 # @Date: 2025-07-23 07:54:25
 # @filename: 
 # @version: 
 # @Description: 
 # @LastEditTime: 2025-07-23 07:54:26
### 
#!/bin/bash


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

# === 检查容器是否运行 ===
echo "🔍 检查容器状态..."
CONTAINERS=("geth" "beacon-chain" "validator")

for name in "${CONTAINERS[@]}"; do
  if docker ps --format '{{.Names}}' | grep -q "$name"; then
    echo "✅ 容器 $name 正在运行"
  else
    echo "❌ 容器 $name 未运行"
  fi
done


# === 检查 Geth RPC 是否响应 ===
echo -e "🔍 检查 Geth JSON-RPC..."
if curl -s --fail -X POST http://$PUBLIC_IP:$GETH_HTTP_PORT \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | grep -q "result"; then
  echo "✅ Geth RPC 响应正常"
else
  echo "❌ Geth RPC 无响应"
fi


echo  -e "🔍 Beacon Chain 状态..."
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://$PUBLIC_IP:$BEACON_GRPC_PORT/eth/v1/node/health)

if [[ "$status_code" == "200" ]]; then
  echo "✅ 正常"
elif [[ "$status_code" == "204" ]]; then
  echo "⚠️ 无健康信息（可能未完成启动或同步）"
else
  echo "❌ 错误（HTTP 状态码: $status_code）"
fi

