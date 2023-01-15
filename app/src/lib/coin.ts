import { env } from "@/config";
import { Coin, GetObjectDataResponse, getObjectFields } from "@mysten/sui.js";
import { Provider } from "./provider";
import { BasicCoin, CoinMetadata } from "./types";

const provider = new Provider(env.suiRpcUrl);

function getInputCoins(
  coins: GetObjectDataResponse[],
  amount: bigint
): string[] {
  const coin = Coin.selectCoinWithBalanceGreaterThanOrEqual(coins, amount);
  if (!coin) {
    const coinSet = Coin.selectCoinSetWithCombinedBalanceGreaterThanOrEqual(
      coins,
      amount
    );

    return coinSet.map((coin) => {
      const fields = getObjectFields(coin);
      return fields?.id.id;
    });
  }

  const fields = getObjectFields(coin);
  return [fields?.id.id];
}

async function getCoinMetadata(type: string): Promise<CoinMetadata> {
  const metadata = await provider.getCoinMetadata(type);
  const iconUrl = metadata.iconUrl
    ? metadata.iconUrl
    : !metadata.iconUrl && type == "0x2::sui::SUI"
    ? "/assets/coins/sui.svg"
    : "/assets/coins/unknown.svg";

  return {
    ...metadata,
    iconUrl,
  };
}

async function getAddressBasicCoins(address: string): Promise<BasicCoin[]> {
  const coinObjects = await provider.getCoinBalancesOwnedByAddress(address);

  const coins: Map<string, BasicCoin> = new Map();

  for (const object of coinObjects) {
    const coinType = <string>Coin.getCoinTypeArg(object);

    if (!coins.has(coinType)) {
      const metadata = await getCoinMetadata(coinType);

      coins.set(coinType, {
        coinType,
        metadata,
      });
    }
  }

  return Array.from(coins.entries()).map((coin) => coin[1]);
}

export const coin = { getInputCoins, getCoinMetadata, getAddressBasicCoins };
