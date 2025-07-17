###
 # @Author: Justin
 # @Date: 2025-07-17 04:36:58
 # @filename: 
 # @version: 
 # @Description: 
 # @LastEditTime: 2025-07-17 05:09:38
### 
docker rm -f $(docker ps -a -q)
rm -Rf ./consensus/beacondata ./consensus/validatordata ./consensus/genesis.ssz
rm -Rf ./execution/geth