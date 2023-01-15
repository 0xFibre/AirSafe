import { CoinMetadata } from "@mysten/sui.js";

export interface CreateSafeData {
  threshold: string;
  owners: string[];
}

export interface SafeData {
  id: string;
  creator: string;
  threshold: number;
  transactionsCount: number;
  owners: string[];
  transactions: string[];
}

export interface DepositCoinData {
  safeId: string;
  amount: string;
  sender: string;
  coin: Coin;
}

export interface DynamicFieldInfo {
  digest: string;
  name: string;
  objectId: string;
  objectType: string;
  type: string;
  version: number;
}

export interface Coin {
  id: string;
  balance: bigint;
  coinType: string;
  metadata: CoinMetadata;
}

export interface CreateSafeTransactionData {
  safeId: string;
  data: string;
  type: number;
}
