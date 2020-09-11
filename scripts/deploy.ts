import { ethers } from '@nomiclabs/buidler';
import { CerFactory } from '../typechain/CerFactory';
import { assertNotEmpty } from '../test/shared/utilities';

async function main() {
  const linkAddress = assertNotEmpty('LINK_CONTRACT_ADDRESS', process.env.LINK_CONTRACT_ADDRESS);
  const oracleAddress = assertNotEmpty('SYMBOL', process.env.SYMBOL);
  const account = (await ethers.getSigners())[0];
  const CER = await new CerFactory(account).deploy(linkAddress, oracleAddress);
  console.log('Deployed CER contract to:', CER.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
