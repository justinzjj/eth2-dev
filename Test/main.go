package main

import (
	"context"
	"fmt"
	"math/big"

	"github.com/ethereum/go-ethereum/accounts/keystore"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
)

func main() {
	client, err := ethclient.Dial("ws://localhost:60011")
	if err != nil {
		fmt.Println("Failed to connect to the Ethereum client:", err)
		return
	}

	keyjson := []byte(`{"address":"123463a4b065722e99115d6c222f267d9cabb524","crypto":{"cipher":"aes-128-ctr","ciphertext":"93b90389b855889b9f91c89fd15b9bd2ae95b06fe8e2314009fc88859fc6fde9","cipherparams":{"iv":"9dc2eff7967505f0e6a40264d1511742"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":262144,"p":1,"r":8,"salt":"c07503bb1b66083c37527cd8f06f8c7c1443d4c724767f625743bd47ae6179a4"},"mac":"6d359be5d6c432d5bbb859484009a4bf1bd71b76e89420c380bd0593ce25a817"},"id":"622df904-0bb1-4236-b254-f1b8dfdff1ec","version":3}`)
	password := "" // 密码

	key, err := keystore.DecryptKey(keyjson, password)
	if err != nil {
		fmt.Println("Failed to decrypt key:", err)
		return
	}
	privateKey := key.PrivateKey
	fromAddress := crypto.PubkeyToAddress(privateKey.PublicKey)

	nonce, err := client.PendingNonceAt(context.Background(), fromAddress)
	if err != nil {
		fmt.Println("Failed to get nonce:", err)
		return
	}
	chainID := big.NewInt(10006)
	gasPrice, err := client.SuggestGasPrice(context.Background())
	if err != nil {
		fmt.Println("Failed to suggest gas price:", err)
		return
	}

	contractBytecode := common.Hex2Bytes("6080604052348015600e575f80fd5b50603e80601a5f395ff3fe60806040525f80fdfea26469706673582212203868997a0e17b3a425ba53c2439ac688fb96239071181e0f948eb2e38853deb364736f6c63430008180033")

	tx := types.NewContractCreation(nonce, big.NewInt(0), 3000000, gasPrice, contractBytecode)
	signedTx, err := types.SignTx(tx, types.NewEIP155Signer(chainID), privateKey)
	if err != nil {
		fmt.Println("Failed to sign transaction:", err)
		return
	}
	client.SendTransaction(context.Background(), signedTx)

	fmt.Println(signedTx.Hash().Hex())
}