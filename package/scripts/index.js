const { JsonRpcProvider, Connection, Transaction, RawSigner, fromExportedKeypair } = require("@mysten/sui.js");

const connection = new Connection({ faucet: "http://127.0.0.1:9123/gas", fullnode: "http:127.0.0.1:9000" });
const provider = new JsonRpcProvider(connection);
const keypair = fromExportedKeypair({
  schema: "Secp256k1",
  privateKey: "SgUKOombnYgIsVNFxECY/JMJqH58HlDl0hT87ZQcyxc=",
});
const signer = new RawSigner(keypair, provider);

async function request() {
  await provider.requestSuiFromFaucet("0xd53ce2b7eb93c7ba25f507fdf7e851a94232d3a9d884bfe96d00cf3a99b9745c");
}

async function test() {
  const tx = new Transaction();

  const c1 = tx.object("0x01ff49b1956f5deae7c08b2e5c18525e58ff79d6e2640b945ca8d4072bb9a761");
  const c2 = tx.object("0x16b9b31c1f65aa00eb40bcdff074fae02dff71e8643cf53491d7fc2340374652");

  tx.mergeCoins(c1, [c2]);

  const s = await signer.signAndExecuteTransaction({ transaction: tx });
  console.log(s);
}

test();
