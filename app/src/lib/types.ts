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

export interface DepositAssetData {
  safeId: string;
  assetId: string;
  assetType: string;
}

export interface ExecuteCoinWithdrawalData {
  safeId: string;
  transactionId: string;
  coin: BasicCoin;
}

export interface ExecuteAssetWithdrawalData {
  safeId: string;
  transactionId: string;
  assetType: string;
}

export interface ExecutePolicyChangeData {
  safeId: string;
  transactionId: string;
}

export interface ApproveTransactionData {
  safeId: string;
  transactionId: string;
}

export interface RejectTransactionData {
  safeId: string;
  transactionId: string;
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

export interface Nft {
  id: string;
  name?: string;
  url: string;
  description?: string;
  type: string;
}

export interface Coin extends BasicCoin {
  id: string;
  balance: bigint;
}

export interface CreateSafeTransactionData {
  safeId: string;
  data: string;
  type: SafeTransactionType;
}

export enum SafeTransactionType {
  COIN_WITHDRAWAL,
  ASSET_WITHDRAWAL,
  ADD_OWNER,
  REMOVE_OWNER,
  CHANGE_THRESHOLD,
}

export enum SafeTransactionStatus {
  ACTIVE,
  APPROVED,
  REJECTED,
  EXECUTED,
}

export interface TransferCoinData {
  coinType: string;
  amount: bigint;
  recipient: string;
}

export const safeTransactionTypeData = {
  [SafeTransactionType.COIN_WITHDRAWAL]: "CoinWithdrawalData",
  [SafeTransactionType.ASSET_WITHDRAWAL]: "WithdrawalData",
  [SafeTransactionType.ADD_OWNER]: "AddOwnerData",
  [SafeTransactionType.REMOVE_OWNER]: "RemoveOwnerData",
  [SafeTransactionType.CHANGE_THRESHOLD]: "ChangeThresholdData",
};

export const safeTransactionTypeValue = {
  [SafeTransactionType.COIN_WITHDRAWAL]: "Coin withdrawal",
  [SafeTransactionType.ASSET_WITHDRAWAL]: "NFT Withdrawal",
  [SafeTransactionType.ADD_OWNER]: "Add owner",
  [SafeTransactionType.REMOVE_OWNER]: "Remove owner",
  [SafeTransactionType.CHANGE_THRESHOLD]: "Change threshold",
};

export const safeTransactionStatusValue = {
  [SafeTransactionStatus.ACTIVE]: "Active",
  [SafeTransactionStatus.APPROVED]: "Approved",
  [SafeTransactionStatus.REJECTED]: "Rejected",
  [SafeTransactionStatus.EXECUTED]: "Executed",
};
