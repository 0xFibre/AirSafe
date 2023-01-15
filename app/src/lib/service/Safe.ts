import { connection, utils } from "@/utils";
import { getObjectFields, getObjectId, ObjectId } from "@mysten/sui.js";
import { coin } from "../coin";
import { Safe } from "../entity";
import { Provider } from "../provider";
import { CreateSafeData, DepositCoinData, SafeData } from "../types";

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

  async getAddressSafes(address: string): Promise<Safe[]> {
    const registry = await this._provider.getObject(this._registryObjectId);

    if (registry.status === "Exists") {
      const safes_table = getObjectFields(getObjectFields(registry)?.safes);
      const ids = await this._getAddressSafeIDs(safes_table?.id.id, address);
      const safesBatch = await this._provider.getObjectBatch(ids);

      return Promise.all(
        safesBatch.map(async (safe) => await this.getSafe(getObjectId(safe)))
      );
    }

    throw new Error("Registry ID not found");
  }

  async getSafe(id: string): Promise<Safe> {
    const safeObject = await this._provider.getObject(id);

    if (safeObject.status === "Exists") {
      const fields = getObjectFields(safeObject);
      return this._buildSafe(fields!);
    }

    throw new Error("Safe not found");
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
}
