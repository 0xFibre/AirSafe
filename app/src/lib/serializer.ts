import { bcs } from "@mysten/sui.js";

bcs.registerStructType("TransferData", {
  coin_type: "vector<u8>",
  amount: "u64",
  recipient: "address",
});

function serialize(type: string, data: any) {
  return `0x${bcs.ser(type, data).toString("hex")}`;
}

function deserialize(type: string, data: string) {
  return bcs.de(type, data, "hex");
}

export const serializer = { serialize, deserialize };
