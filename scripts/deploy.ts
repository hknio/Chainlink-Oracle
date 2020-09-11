import { ethers } from '@nomiclabs/buidler';
import { CerFactory } from '../typechain/CerFactory';
import { assertNotEmpty } from '../test/shared/utilities';

async function main() {
  const linkAddress = assertNotEmpty('LINK_CONTRACT_ADDRESS', process.env.LINK_CONTRACT_ADDRESS);
  const oracleAddress = assertNotEmpty('SYMBOL', process.env.SYMBOL);
  const validationJobId = assertNotEmpty('REQUEST_VALIDATION_JOB_ID', process.env.REQUEST_VALIDATION_JOB_ID);
  const certificateCertificationJobId = assertNotEmpty(
    'REQUEST_CERTIFICATE_CERTIFICATION_JOB_ID',
    process.env.REQUEST_CERTIFICATE_CERTIFICATION_JOB_ID,
  );
  const defiAuditJobId = assertNotEmpty('REQUEST_DEFI_AUDIT_JOB_ID', process.env.REQUEST_DEFI_AUDIT_JOB_ID);
  const defiLastAuditDateJobId = assertNotEmpty(
    'REQUEST_DEFI_LAST_AUDIT_DATE_JOB_ID',
    process.env.REQUEST_DEFI_LAST_AUDIT_DATE_JOB_ID,
  );
  const account = (await ethers.getSigners())[0];
  const CER = await new CerFactory(account).deploy(
    linkAddress,
    oracleAddress,
    validationJobId,
    certificateCertificationJobId,
    defiAuditJobId,
    defiLastAuditDateJobId,
  );
  console.log('Deployed CER contract to:', CER.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
