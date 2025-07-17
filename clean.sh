###
 # @Author: Justin
 # @Date: 2025-07-17 04:36:58
 # @filename: 
 # @version: 
 # @Description: 
 # @LastEditTime: 2025-07-17 11:43:08
### 
docker rm -f $(docker ps -a -q)
rm -Rf ./consensus/node1/beacondata  ./consensus/genesis.ssz
rm -Rf ./consensus/node2/beacondata  ./consensus/genesis.ssz
rm -Rf ./consensus/validatordata
rm -Rf ./execution/node1/geth
rm -Rf ./execution/node2/geth