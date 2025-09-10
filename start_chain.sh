###
 # @Author: Justin
 # @Date: 2025-07-18 09:51:37
 # @filename: 
 # @version: 
 # @Description: 
 # @LastEditTime: 2025-07-19 05:58:02
### 
#!/bin/bash
-set -e
# 函数：启动主节点
start_main_node() {
  echo "🚀 启动主节点..."
  docker compose up create-beacon-chain-genesis geth-remove-db -d
  docker compose up geth-genesis -d
  docker compose up beacon-chain -d
  docker compose up geth -d
  docker compose up validator -d
  docker compose up root-change -d
  echo "✅ 主节点启动完成！"
}

# 函数：分发节点信息
distribute_info() {
  echo "🔄 分发节点信息..."
  cd script && ./send_info.sh
  echo "✅ 节点信息已分发！"
}

# 函数：启动分节点
start_sub_node() {
  # 检查是否存在 genesis 文件
  if [ ! -f "./consensus/genesis.ssz" ]; then
    echo "❌ 错误：未找到 genesis.ssz 文件，请先运行主节点生成该文件。"
    exit 1
  fi

  echo "🚀 启动分节点..."
  docker compose up geth-genesis -d
  docker compose up beacon-chain -d
  docker compose up geth -d
  docker compose up root-change -d
  echo "✅ 分节点启动完成！"
}


while getopts "mds" opt; do
  case $opt in
    m)
      start_main_node
      ;;
    d)
        distribute_info
      ;;
    s)
      start_sub_node
      ;;
    *)
      echo "用法: $0 [-m] [-d] [-s]"
      exit 1
      ;;
  esac
done
