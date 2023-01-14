import { SafeData } from "../types";

export class Safe implements SafeData {
  public id: string;
  public creator: string;
  public owners: string[];
  public threshold: number;
  public transactions: string[];
  public transactionsCount: number;

  constructor(data: SafeData) {
    this.id = data.id;
    this.creator = data.creator;
    this.owners = data.owners;
    this.threshold = data.threshold;
    this.transactionsCount = data.transactionsCount;
    this.transactions = data.transactions;
  }
}
