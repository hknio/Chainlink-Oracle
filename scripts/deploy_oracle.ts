import { assertNotEmpty } from '../test/shared/utilities';
import { ethers } from '@nomiclabs/buidler';
import { OracleFactory } from '../typechain/OracleFactory';
import { TransactionOverrides } from '../typechain';

async function main() {
  const gasPriceString = assertNotEmpty('GAS_PRICE_GWEI', process.env.GAS_PRICE_GWEI);
  const gasPrice = ethers.utils.parseUnits(gasPriceString, 9);
  const overrides: TransactionOverrides = { gasPrice: gasPrice };
  const linkAddress = assertNotEmpty('LINK_CONTRACT_ADDRESS', process.env.LINK_CONTRACT_ADDRESS);
  const nodeAddress = assertNotEmpty('CHAINLINK_NODE_ADDRESS', process.env.CHAINLINK_NODE_ADDRESS);
  const account = (await ethers.getSigners())[0];
  const Oracle = await new OracleFactory(account).deploy(linkAddress, overrides);
  console.log('Deployed Oracle contract to: ', Oracle.address);
  await Oracle.setFulfillmentPermission(nodeAddress, true, overrides);
  console.log('Set fulfillment permission for: ', nodeAddress);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
