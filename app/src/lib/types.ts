import { ObjectId } from "@mysten/sui.js";

export type address = string;

export interface CreateSafeData {
  threshold: string;
  owners: address[];
}

export interface SafeData {
  id: ObjectId;
  creator: address;
  threshold: number;
  transactionsCount: number;
  owners: address[];
  transactions: ObjectId[];
}
