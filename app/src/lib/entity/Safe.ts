import { env } from "@/config";
import { Coin as CoinAPI, getMoveObjectType } from "@mysten/sui.js";
import { Provider } from "../provider";
import { Coin, SafeData } from "../types";

const provider = new Provider(env.suiRpcUrl);

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

  async getCoinBalances(): Promise<Coin[]> {
    const dynamicFields = await provider.getDynamicFields(this.id);
    return Promise.all(
      dynamicFields.map((field) => this.getCoin(field.objectId))
    );
  }

  async getCoin(id: string): Promise<Coin> {
    const object = await provider.getObject(id);

    if (object.status === "Exists") {
      if (!CoinAPI.isCoin(object)) {
        throw new Error("Object is not a coin");
      }

      const coinType = CoinAPI.getCoinType(getMoveObjectType(object)!);
      const metadata = await provider.getCoinMetadata(coinType!);
      const balance = CoinAPI.getBalance(object);

      return {
        id,
        coinType,
        metadata,
        balance,
      };
    }

    throw new Error("Object not found");
  }
}
