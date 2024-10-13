-include .env		

deploy-sepolia:																																																					
	forge script script/DeployStorageFun.s.sol:DeployFunWithStorage --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_Key) --broadcast --verify  -vvvv

sepolia-verify:
	forge verify-contract --etherscan-api-key $(EthErcan_api_key) --compiler-version v0.8.19 --chain-id 11155111 0x75Fc15B7cC133082bB9687f9AF0705880F8b1Da9 script/DeployStorageFun.s.sol:DeployFunWithStorage 


build:
	forge build