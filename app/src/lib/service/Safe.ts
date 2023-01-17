import { connection, utils } from "@/utils";
import { getObjectFields, getObjectId, ObjectId, bcs } from "@mysten/sui.js";
import { coin } from "../coin";
import { Safe, SafeTransaction } from "../entity";
import { Provider } from "../provider";
import { serializer } from "../serializer";
import {
  ApproveTransactionData,
  CreateSafeData,
  CreateSafeTransactionData,
  DepositCoinData,
  ExecuteCoinWithdrawalData,
  SafeData,
  SafeTransactionData,
  SafeTransactionType,
} from "../types";

interface ConstructorData {
  packageObjectId: ObjectId;
  registryObjectId: ObjectId;
  rpcUrl: string;
}

export class SafeService {
  private _packageObjectId: ObjectId;
  private _registryObjectId: ObjectId;
  private _provider: Provider;

  constructor(data: ConstructorData) {
    this._packageObjectId = data.packageObjectId;
    this._registryObjectId = data.registryObjectId;
    this._provider = new Provider(data.rpcUrl);
  }

  get module() {
    return "main";
  }

  async createSafe(data: CreateSafeData) {
    const moveCallPayload = {
      packageObjectId: this._packageObjectId,
      module: this.module,
      function: "create_safe",
      typeArguments: [],
      arguments: [this._registryObjectId, String(data.threshold), data.owners],
    };

    return await connection.executeMoveCall(moveCallPayload);
  }

  // async depositCoin(data: DepositCoinData) {
  //   const moveCallPayload = {
  //     packageObjectId: this._packageObjectId,
  //     module: this.module,
  //     function: "deposit_coin",
  //     typeArguments: ["0x2::sui::SUI"],
  //     arguments: [
  //       data.safeId,
  //       ["0x409d701d5041b6a1a892cadddd4be3e130c18a99"],
  //       "100000",
  //     ],
  //   };

  //   return await connection.executeMoveCall(moveCallPayload);
  // }

  async depositCoin(data: DepositCoinData) {
    const {
      sender,
      coin: { coinType, metadata },
    } = data;

    const amount = utils
      .parseBalance(data.amount, metadata.decimals)
      .toString();

    const coins = await this._provider.getCoinBalancesOwnedByAddress(
      sender,
      coinType
    );
    const inputCoins = coin.getInputCoins(coins, BigInt(amount));

    if (inputCoins.length < 1) {
      throw new Error("Insufficient balance");
    }

    const moveCallPayload = {
      packageObjectId: this._packageObjectId,
      module: this.module,
      function: "deposit_coin",
      typeArguments: [data.coin.coinType],
      arguments: [data.safeId, inputCoins, amount],
    };

    return await connection.executeMoveCall(moveCallPayload);
  }

  async createTransaction(data: CreateSafeTransactionData) {
    const moveCallPayload = {
      packageObjectId: this._packageObjectId,
      module: this.module,
      function: "create_transaction",
      typeArguments: [],
      arguments: [data.safeId, data.type, data.data],
    };

    return await connection.executeMoveCall(moveCallPayload);
  }

  async approveTransaction(data: ApproveTransactionData) {
    const moveCallPayload = {
      packageObjectId: this._packageObjectId,
      module: this.module,
      function: "approve_transaction",
      typeArguments: [],
      arguments: [data.safeId, data.transactionId],
    };

    return await connection.executeMoveCall(moveCallPayload);
  }

  async rejectTransaction(data: ApproveTransactionData) {
    const moveCallPayload = {
      packageObjectId: this._packageObjectId,
      module: this.module,
      function: "reject_transaction",
      typeArguments: [],
      arguments: [data.safeId, data.transactionId],
    };

    return await connection.executeMoveCall(moveCallPayload);
  }

  async executeCoinWithdrawal(data: ExecuteCoinWithdrawalData) {
    const moveCallPayload = {
      packageObjectId: this._packageObjectId,
      module: this.module,
      function: "execute_coin_withdrawal",
      typeArguments: [data.coin.coinType],
      arguments: [data.safeId, data.transactionId],
    };

    return await connection.executeMoveCall(moveCallPayload);
  }

  async getAddressSafes(address: string): Promise<Safe[]> {
    const registry = await this._provider.getObject(this._registryObjectId);

    if (registry.status === "Exists") {
      const safes_table = getObjectFields(getObjectFields(registry)?.safes);
      const ids = await this._getAddressSafeIDs(safes_table?.id.id, address);
      const safesBatch = await this._provider.getObjectBatch(ids);

      return safesBatch.map((safe) => this._buildSafe(getObjectFields(safe)!));
    }

    throw new Error("Registry ID not found");
  }

  async getSafe(safeId: string): Promise<Safe> {
    const safeObject = await this._provider.getObject(safeId);

    if (safeObject.status === "Exists") {
      const fields = getObjectFields(safeObject);
      return this._buildSafe(fields!);
    }

    throw new Error("Safe not found");
  }

  async getSafeTransactions(ids: string[]): Promise<SafeTransaction[]> {
    const objectBatch = await this._provider.getObjectBatch(ids);

    return Promise.all(
      objectBatch.map(
        async (transaction) =>
          await this._buildSafeTransaction(getObjectFields(transaction)!)
      )
    );
  }

  async getSafeTransaction(id: string): Promise<SafeTransaction> {
    const transactionObject = await this._provider.getObject(id);

    if (transactionObject.status === "Exists") {
      const fields = getObjectFields(transactionObject);
      return await this._buildSafeTransaction(fields!);
    }

    throw new Error("Transaction not found");
  }

  async _getAddressSafeIDs(id: string, address: string) {
    try {
      const safes = await this._provider.getDynamicFieldObject(id, address);
      const ids = getObjectFields(getObjectFields(safes)?.value);
      return ids?.contents;
    } catch (e) {
      const msg = `Error fetching dynamic fields: Error: RPC Error: Cannot find dynamic field [${address}] for object [${id}]. for id ${id}`;
      const err = e as unknown as Error;
      if (err.message === msg) return [];
      throw e;
    }
  }

  private _buildSafe(fields: Record<string, any>): Safe {
    const owners = getObjectFields(fields.owners);

    const data: SafeData = {
      creator: fields.creator,
      id: fields.id.id,
      owners: owners?.contents,
      threshold: fields.threshold,
      transactions: fields.transactions,
      transactionsCount: fields.transactions_count,
    };

    return new Safe(data);
  }

  private async _buildSafeTransaction(
    fields: Record<string, any>
  ): Promise<SafeTransaction> {
    const approvers = getObjectFields(fields.approvers);
    const rejecters = getObjectFields(fields.rejecters);

    const input = this._deserializeSafeTransactionData(
      fields.type,
      fields.data
    );

    const data: SafeTransactionData = {
      id: fields.id.id,
      status: fields.status,
      creator: fields.creator,
      index: fields.index,
      safeId: fields.safe_id,
      type: fields.type,
      data: fields.data,
      input,
      coin: input.coinType
        ? {
            coinType: input.coinType,
            metadata: await coin.getCoinMetadata(input.coinType),
          }
        : undefined,
      approvers: approvers?.contents,
      rejecters: rejecters?.contents,
    };

    return new SafeTransaction(data);
  }

  private _deserializeSafeTransactionData(
    type: SafeTransactionType,
    data: number[]
  ) {
    const safeTransactionTypeData = {
      [SafeTransactionType.None]: "",
      [SafeTransactionType.TRANSFER]: "TransferData",
    };

    const typeData = safeTransactionTypeData[type];
    const result = serializer.deserialize(typeData, Uint8Array.from(data));

    if (type === SafeTransactionType.TRANSFER) {
      return {
        coinType: Buffer.from(result.coin_type).toString(),
        amount: result.amount,
        recipient: result.recipient,
      };
    }

    throw new Error("");
  }
}
