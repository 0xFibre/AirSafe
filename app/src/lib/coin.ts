import { Coin, GetObjectDataResponse, getObjectFields } from "@mysten/sui.js";

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

export const coin = { getInputCoins };
