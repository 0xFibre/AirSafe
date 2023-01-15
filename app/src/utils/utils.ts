import { BigNumber } from "bignumber.js";

export const utils = {
  truncate0x(address: string) {
    const regex = /^(0x[a-zA-Z0-9]{5})[a-zA-Z0-9]+([a-zA-Z0-9]{5})$/;
    const match = address.match(regex);

    if (!match) return address;
    return `${match[1]}…${match[2]}`;
  },

  formatBalance(balance: bigint | number, decimals: number) {
    const value = new BigNumber(balance.toString());
    return value.div(Math.pow(10, decimals));
  },

  parseBalance(balance: string, decimals: number) {
    const value = new BigNumber(balance);
    return value.times(Math.pow(10, decimals));
  },
};
