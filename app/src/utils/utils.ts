import { BigNumber } from "bignumber.js";

BigNumber.config({ EXPONENTIAL_AT: [-100, 100] });
export const utils = {
  truncate0x(address: string) {
    const regex = /^(0x[a-zA-Z0-9]{5})[a-zA-Z0-9]+([a-zA-Z0-9]{5})$/;
    const match = address.match(regex);

    if (!match) return address;
    return `${match[1]}…${match[2]}`;
  },

  formatBalance(balance: bigint | number, decimals: number) {
    const value = new BigNumber(balance.toString());
    return value.shiftedBy(-decimals);
  },

  parseBalance(balance: string, decimals: number) {
    const value = new BigNumber(balance);
    return value.shiftedBy(decimals);
  },
};
