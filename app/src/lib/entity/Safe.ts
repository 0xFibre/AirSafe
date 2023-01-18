import { env } from "@/config";
import {
  Coin as CoinAPI,
  getMoveObjectType,
  getObjectFields,
  getObjectId,
} from "@mysten/sui.js";
import { Provider } from "../provider";
import { nft } from "../nft";
import { Coin, Nft, SafeData } from "../types";

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

  async getNfts(): Promise<Nft[]> {
    const dynamicFields = await provider.getDynamicFields(this.id);

    const nfts = [];
    for (let i = 0; i < dynamicFields.length; i++) {
      const field = dynamicFields[i];
      const nft = await this.getNft(field.objectId);

      if (nft) {
        nfts.push(nft);
      }
    }

    return nfts;
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

      const iconUrl = metadata.iconUrl
        ? metadata.iconUrl
        : !metadata.iconUrl && CoinAPI.isSUI(object)
        ? "/assets/coins/sui.svg"
        : "/assets/coins/unknown.svg";

      return {
        id,
        metadata: {
          ...metadata,
          iconUrl,
        },
        coinType: coinType!,
        balance: balance || 0n,
      };
    }

    throw new Error("Object not found");
  }

  async getNft(id: string): Promise<Nft | undefined> {
    const object = await provider.getObject(id);

    const fields = getObjectFields(object);

    // @ts-expect-error
    if (nft.isNft(object.details)) {
      return {
        id: getObjectId(object),
        name: fields?.name,
        description: fields?.description,
        url: nft.parseUrl(fields?.url),
        type: getMoveObjectType(object)!,
      };
    }
  }
}
