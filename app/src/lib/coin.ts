import { env } from "@/config";
import { Coin, GetObjectDataResponse, getObjectFields } from "@mysten/sui.js";
import { Provider } from "./provider";
import { CoinMetadata } from "./types";

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

export const coin = { getInputCoins, getCoinMetadata };
