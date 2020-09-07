import { ethers } from '@nomiclabs/buidler';
import { CerFactory } from '../typechain/CerFactory';

async function main() {
  const account = (await ethers.getSigners())[0];
  const CER = await new CerFactory(account).deploy();
  console.log('Deployed CER contract to:', CER.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
