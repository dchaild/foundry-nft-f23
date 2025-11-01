-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil zktest

SEPOLIA_PRIVATE_KEY := 0x4656f1c453661acde77908040951d5fda3d315f655f76c122b0d011b1d8adc06
DEFAULT_ZKSYNC_LOCAL_KEY := 0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install cyfrin/foundry-devops@0.2.2 --no-commit && forge install foundry-rs/forge-std@v1.8.2 --no-commit && forge install openzeppelin/openzeppelin-contracts@v5.0.2 --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

zktest :; foundryup-zksync && forge test --zksync && foundryup

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast


ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

deploy:
	@forge script script/DeployBasicNft.s.sol:DeployBasicNft $(NETWORK_ARGS)
COMPILER_VERSION := $(shell cat foundry.toml | grep "solc_version" | cut -d '"' -f 2)
verify:
	@forge verify-contract --chain-id 11155111 --num-of-optimizations 200 --watch --constructor-args `cast abi-encode "constructor()"` --compiler-version $(COMPILER_VERSION) $(DEPLOYED_CONTRACT_ADDRESS) src/BasicNft.sol:BasicNft --etherscan-api-key $(ETHERSCAN_API_KEY)
# Note: Replace <YOUR_CONTRACT_ADDRESS> with the address of your deployed BasicNft contract.
# You can find this address in the output of the `deploy` command or in the `broadcast/` directory.


mint:
	@forge script script/Interactions.s.sol:MintBasicNft ${NETWORK_ARGS}

deployMood:
	@forge script script/DeployMoodNft.s.sol:DeployMoodNft $(NETWORK_ARGS)

mintMoodNft:
	@forge script script/Interactions.s.sol:MintMoodNft $(NETWORK_ARGS)

flipMoodNft:
	@forge script script/Interactions.s.sol:FlipMoodNft $(NETWORK_ARGS)

zkdeploy: 
	@forge create src/OurToken.sol:OurToken $(NETWORK_ARGS)