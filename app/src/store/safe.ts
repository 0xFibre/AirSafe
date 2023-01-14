import { Safe } from "@/lib/entity";
import { safeService } from "@/lib/service";
import { defineStore } from "pinia";
import { useConnectionStore } from "./connection";

export const useSafeStore = defineStore("safe", {
  state: () =>
    <{ safes: Safe[] }>{
      safes: [],
    },

  actions: {
    async createSafe(threshold: string, owners: string[]) {
      const result = await safeService.createSafe({ threshold, owners });
      console.log(result);
    },

    async fetchSafes() {
      const { address } = useConnectionStore();
      const safes = await safeService.getAddressSafes(address);
      this.safes = safes;
    },
  },
});
