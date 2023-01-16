import { SafeTransaction } from "@/lib/entity";
import { safeService } from "@/lib/service";
import { defineStore } from "pinia";
import { useSafeStore } from "./safe";

export const useTransactionStore = defineStore("transaction", {
  state: () =>
    <{ transactions: SafeTransaction[]; transaction?: SafeTransaction }>{
      transactions: [],
      transaction: undefined,
    },

  actions: {
    // async createTransaction(threshold: string, owners: string[]) {
    //   const result = await safeService.createTransaction({
    //     threshold,
    //     owners,
    //   });
    //   console.log(result);
    // },

    async fetchTransactions() {
      const { safe } = useSafeStore();
      this.transactions = await safeService.getSafeTransactions(
        safe?.transactions!
      );
    },
  },
});
