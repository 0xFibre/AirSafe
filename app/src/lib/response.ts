import { SuiTransactionResponse } from "@mysten/sui.js";

export const response = {
  validateSuiTransactionResponse(tx: SuiTransactionResponse) {
    const { effects } = tx;

    if (effects.status.status !== "success") {
      throw new Error(effects.status.error);
    }

    return tx;
  },
};
