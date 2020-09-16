# CER Oracle
CER Oracle provides Security Audit Data for DeFi and crypto exchanges. The data produced from the audits are submitted to the CER.live platform, where Chainlink nodes can retrieve the data and make it available for smart contracts to consume as needed. Users can use an aggregation of multiple independent Chainlink Nodes to ensure the availability and tamperproofness of the data delivery process.

#  Installation
1. Make sure to use node 10.20.1
2. Run `npm install` in project root directory
3. Create `.env` file:
```
MNEMONIC_OR_PRIVATE_KEY={YOUR_PRIVATE_KEY}
INFURA_API_KEY={YOUR_INFURA_API_KEY}
CHAINLINK_NODE_ADDRESS={CHAINLINK_NODE_ADDRESS}
LINK_CONTRACT_ADDRESS={LINK_CONTRACT_ADDRESS}
ORACLE_CONTRACT_ADDRESS={ORACLE_CONTRACT_ADDRESS}
REQUEST_VALIDATION_JOB_ID={REQUEST_VALIDATION_JOB_ID}
REQUEST_CERTIFICATE_CYBERSECURITY_SCORE_JOB_ID={REQUEST_CERTIFICATE_CYBERSECURITY_SCORE_JOB_ID}
REQUEST_CERTIFICATE_PENETRATION_TEST_STATUS_JOB_ID={REQUEST_CERTIFICATE_PENETRATION_TEST_STATUS_JOB_ID}
REQUEST_CERTIFICATE_PENETRATION_TEST_ACTIVE_UNTIL_JOB_ID={REQUEST_CERTIFICATE_PENETRATION_TEST_ACTIVE_UNTIL_JOB_ID}
REQUEST_CERTIFICATE_BUG_BOUNTY_STATUS_JOB_ID={REQUEST_CERTIFICATE_BUG_BOUNTY_STATUS_JOB_ID}
REQUEST_CERTIFICATE_PROOF_OF_FUNDS_STATUS_JOB_ID={REQUEST_CERTIFICATE_PROOF_OF_FUNDS_STATUS_JOB_ID}
REQUEST_DEFI_AUDIT_JOB_ID={REQUEST_DEFI_AUDIT_JOB_ID}
REQUEST_DEFI_LAST_AUDIT_DATE_JOB_ID={REQUEST_DEFI_LAST_AUDIT_DATE_JOB_ID}
REQUEST_DEFI_BUG_BOUNTY_JOB_ID={REQUEST_DEFI_BUG_BOUNTY_JOB_ID}
```
4. Run `npm run rebuild` in project root directory
5. Deploy oracle `GAS_PRICE_GWEI={GAS_PRICE_GWEI} npx buidler run --network <your-network> scripts/deploy_oracle.ts`
6. Deploy contract `GAS_PRICE_GWEI={GAS_PRICE_GWEI} npx buidler run --network <your-network> scripts/deploy.ts`

#  Boilerplate

This is a starter kit for developing, testing, and deploying smart contracts with a full Typescript environment. This stack uses [Buidler](https://buidler.dev) as the platform layer to orchestrate all the tasks. [Ethers](https://docs.ethers.io/ethers.js/html/index.html) is used for all Ethereum interactions and testing.

[Blog Post](https://medium.com/@rahulsethuram/the-new-solidity-dev-stack-buidler-ethers-waffle-typescript-tutorial-f07917de48ae)
