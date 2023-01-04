const fs = require('fs/promises');
const { initialize } = require('zokrates-js')
const ethers = require('ethers');

const userCreditScore = 744;
const creditScoreThreshold = 750;

initialize().then(async (zokratesProvider) => {
  // zokrates generation/client-side artifacts
  const program = Uint8Array.from(Buffer.from((await fs.readFile('zkp/simple')).toString('hex'), 'hex'));
  const provingKey = Uint8Array.from(Buffer.from((await fs.readFile('zkp/proving.key')).toString('hex'), 'hex'));
  
  // zokrates verification/server-side artifacts
  // const verificationKey = JSON.parse((await fs.readFile('zkp/verification.key')).toString());

  // computation
  console.log('');
  console.log('---------- CLIENT-SIDE PROOF GENERATION STAGE ----------');
  console.log('Checking your credit score.');
  
  let witnessOutput;
  let proof;
  try {
    witnessOutput = zokratesProvider.computeWitness(program, [userCreditScore.toString(), creditScoreThreshold.toString()]);
    proof = zokratesProvider.generateProof(program, witnessOutput.witness, provingKey);
  } catch (e) {
    console.log(`Oh no!! Your credit score of ${userCreditScore} isn't equal to or above the threshold of ${creditScoreThreshold}. That stinks.`);
    process.exit();
  }
  console.log(`Your credit score of ${userCreditScore} is equal to or above the threshold of ${creditScoreThreshold}! Generating a proof now.`);
  console.log('Proof successfully generated!');

  // verification
  console.log('');
  console.log('---------- SERVER/CONTRACT-SIDE PROOF VERIFICATION STAGE ----------');
  console.log('Verifying proof.');

  // const validProof = zokratesProvider.verify(verificationKey, proof);
  // if (!validProof) {
  //   console.log('Oh no!! The proof is not valid.')
  //   process.exit();
  // }

  const provider = new ethers.providers.JsonRpcProvider("http://127.0.0.1:8545");
  const signer = provider.getSigner();

  const abi = JSON.parse((await fs.readFile('scripts/abi.json')).toString());

  const verifierAddress = '0x0165878A594ca255338adfa4d48449f69242Eb8F';
  const contract = new ethers.Contract(verifierAddress, abi, signer);

  let validProof = false;
  try {
    validProof = await contract.verifyTx(proof.proof, proof.inputs);
  } catch (e) {
    console.log('Oh no!! The proof is not valid.')
    process.exit();
  }
  if (!validProof) {
    console.log('Oh no!! The proof is not valid.')
    process.exit();
  }

  console.log(`The proof is valid! Your credit score has been verified to be above ${creditScoreThreshold} without revealing what it is.`)
});
