#!/bin/bash
set -e

###
 # @Author: Justin
 # @Date: 2025-11-04 06:53:32
 # @filename: 
 # @version: 
 # @Description: 
 # @LastEditTime: 2025-11-04 07:06:30
### 
###

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




while getopts "m" opt; do
  case $opt in
    m)
      start_main_node
      ;;
    *)
      echo "用法: $0 [-m]"
      exit 1
      ;;
  esac
done