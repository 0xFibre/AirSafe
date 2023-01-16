import { CoinMetadata as Metadata } from "@mysten/sui.js";

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

export interface SafeTransactionData {
  id: string;
  index: number;
  safeId: string;
  type: SafeTransactionType;
  status: SafeTransactionStatus;
  creator: string;
  data: number[];
  input: any;
  coin?: BasicCoin;
  approvers: string[];
  rejecters: string[];
}

export interface DepositCoinData {
  safeId: string;
  amount: string;
  sender: string;
  coin: BasicCoin;
}

export interface DynamicFieldInfo {
  digest: string;
  name: string;
  objectId: string;
  objectType: string;
  type: string;
  version: number;
}

export interface CoinMetadata extends Metadata {
  iconUrl: string;
}

export interface BasicCoin {
  coinType: string;
  metadata: CoinMetadata;
}

export interface Coin extends BasicCoin {
  id: string;
  balance: bigint;
}

export interface CreateSafeTransactionData {
  safeId: string;
  data: string;
  type: number;
}

export enum SafeTransactionType {
  None,
  TRANSFER,
}

export enum SafeTransactionStatus {
  None,
  ACTIVE,
  REJECTED,
  APPROVED,
  READY,
  EXECUTED,
}

export interface TransferCoinData {
  coinType: string;
  amount: bigint;
  recipient: string;
}
