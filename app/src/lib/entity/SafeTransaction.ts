import { serializer } from "../serializer";
import {
  BasicCoin,
  SafeTransactionData,
  SafeTransactionStatus,
  SafeTransactionType,
} from "../types";

export const safeTransactionTypeValue = {
  [SafeTransactionType.None]: "",
  [SafeTransactionType.TRANSFER]: "Coin Transfer",
};

export const safeTransactionStatusValue = {
  [SafeTransactionType.None]: "",
  [SafeTransactionStatus.ACTIVE]: "Active",
  [SafeTransactionStatus.APPROVED]: "Approved",
  [SafeTransactionStatus.REJECTED]: "Rejected",
  [SafeTransactionStatus.EXECUTED]: "Executed",
};

export class SafeTransaction implements SafeTransactionData {
  public id: string;
  public type: SafeTransactionType;
  public status: SafeTransactionStatus;
  public creator: string;
  public rejecters: string[];
  public approvers: string[];
  public index: number;
  public safeId: string;
  public input: any;
  public coin?: BasicCoin;
  public data: number[];

  constructor(data: SafeTransactionData) {
    this.id = data.id;
    this.type = data.type;
    this.status = data.status;
    this.creator = data.creator;
    this.rejecters = data.rejecters;
    this.approvers = data.approvers;
    this.index = data.index;
    this.safeId = data.safeId;
    this.data = data.data;
    this.input = data.input;
    this.coin = data.coin;
  }

  get typeValue() {
    return safeTransactionTypeValue[this.type];
  }

  get statusValue() {
    return safeTransactionStatusValue[this.status];
  }
}
