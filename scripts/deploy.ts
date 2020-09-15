import { ethers } from '@nomiclabs/buidler';
import { CerFactory } from '../typechain/CerFactory';
import { assertNotEmpty } from '../test/shared/utilities';
import { TransactionOverrides } from '../typechain';

async function main() {
  const gasPriceString = assertNotEmpty('GAS_PRICE_GWEI', process.env.GAS_PRICE_GWEI);
  const gasPrice = ethers.utils.parseUnits(gasPriceString, 9);
  const overrides: TransactionOverrides = { gasPrice: gasPrice };
  const linkAddress = assertNotEmpty('LINK_CONTRACT_ADDRESS', process.env.LINK_CONTRACT_ADDRESS);
  const oracleAddress = assertNotEmpty('SYMBOL', process.env.SYMBOL);
  const validationJobId = assertNotEmpty('REQUEST_VALIDATION_JOB_ID', process.env.REQUEST_VALIDATION_JOB_ID);
  const certificateCybersecurityScoreJobId = assertNotEmpty(
    'REQUEST_CERTIFICATE_CYBERSECURITY_SCORE_JOB_ID',
    process.env.REQUEST_CERTIFICATE_CYBERSECURITY_SCORE_JOB_ID,
  );
  const certificatePenetrationTestStatusJobId = assertNotEmpty(
    'REQUEST_CERTIFICATE_PENETRATION_TEST_STATUS_JOB_ID',
    process.env.REQUEST_CERTIFICATE_PENETRATION_TEST_STATUS_JOB_ID,
  );
  const certificatePenetrationTestActiveUntileJobId = assertNotEmpty(
    'REQUEST_CERTIFICATE_PENETRATION_TEST_ACTIVE_UNTIL_JOB_ID',
    process.env.REQUEST_CERTIFICATE_PENETRATION_TEST_ACTIVE_UNTIL_JOB_ID,
  );
  const certificateBugBountyStatusJobId = assertNotEmpty(
    'REQUEST_CERTIFICATE_BUG_BOUNTY_STATUS_JOB_ID',
    process.env.REQUEST_CERTIFICATE_BUG_BOUNTY_STATUS_JOB_ID,
  );
  const certificateProofOfFundsStatusJobId = assertNotEmpty(
    'REQUEST_CERTIFICATE_PROOF_OF_FUNDS_STATUS_JOB_ID',
    process.env.REQUEST_CERTIFICATE_PROOF_OF_FUNDS_STATUS_JOB_ID,
  );
  const defiAuditJobId = assertNotEmpty('REQUEST_DEFI_AUDIT_JOB_ID', process.env.REQUEST_DEFI_AUDIT_JOB_ID);
  const defiLastAuditDateJobId = assertNotEmpty(
    'REQUEST_DEFI_LAST_AUDIT_DATE_JOB_ID',
    process.env.REQUEST_DEFI_LAST_AUDIT_DATE_JOB_ID,
  );
  const defiBugBountyJobId = assertNotEmpty(
    'REQUEST_DEFI_BUG_BOUNTY_JOB_ID',
    process.env.REQUEST_DEFI_BUG_BOUNTY_JOB_ID,
  );
  const account = (await ethers.getSigners())[0];
  const CER = await new CerFactory(account).deploy(
    linkAddress,
    oracleAddress,
    validationJobId,
    certificateCybersecurityScoreJobId,
    certificatePenetrationTestStatusJobId,
    certificatePenetrationTestActiveUntileJobId,
    certificateBugBountyStatusJobId,
    certificateProofOfFundsStatusJobId,
    defiAuditJobId,
    defiLastAuditDateJobId,
    defiBugBountyJobId,
    10 ** 18,
    overrides,
  );
  console.log('Deployed CER contract to:', CER.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
