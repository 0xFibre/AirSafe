import { bcs } from "@mysten/sui.js";
import { safeTransactionTypeData, SafeTransactionType } from "./types";

bcs
  .registerStructType(
    safeTransactionTypeData[SafeTransactionType.COIN_WITHDRAWAL],
    {
      coin_type: "vector<u8>",
      amount: "u64",
      recipient: "address",
    }
  )
  .registerStructType(safeTransactionTypeData[SafeTransactionType.ADD_OWNER], {
    owner: "address",
    threshold: "u64",
  })
  .registerStructType(
    safeTransactionTypeData[SafeTransactionType.REMOVE_OWNER],
    {
      owner: "address",
      threshold: "u64",
    }
  )
  .registerStructType(
    safeTransactionTypeData[SafeTransactionType.CHANGE_THRESHOLD],
    {
      threshold: "u64",
    }
  );

function serialize(type: string, data: any) {
  return `0x${bcs.ser(type, data).toString("hex")}`;
}

function deserialize(
  type: string,
  data: string | Uint8Array,
  encoding?: string
) {
  return bcs.de(type, data, encoding);
}

export const serializer = { serialize, deserialize };
