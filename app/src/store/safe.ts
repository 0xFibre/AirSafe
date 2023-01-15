import { Safe } from "@/lib/entity";
import { safeService } from "@/lib/service";
import { Coin } from "@/lib/types";
import { useLocalStorage } from "@vueuse/core";
import { defineStore } from "pinia";
import { useConnectionStore } from "./connection";

export const useSafeStore = defineStore("safe", {
  state: () =>
    <{ safes: Safe[]; safe?: Safe; activeSafeId: string | null }>{
      safes: [],
      activeSafeId: <string | null>(
        (<unknown>useLocalStorage("activeSafeId", null))
      ),
      safe: undefined,
    },

  actions: {
    async createSafe(threshold: string, owners: string[]) {
      const result = await safeService.createSafe({ threshold, owners });
      console.log(result);
    },

    async fetchSafes() {
      const { address } = useConnectionStore();
      this.safes = await safeService.getAddressSafes(address);
    },

    async fetchActiveSafe() {
      if (this.activeSafeId) {
        this.safe = await safeService.getSafe(this.activeSafeId);
      } else {
        throw new Error("No active safe");
      }
    },

    async setActiveSafeId(id: string) {
      const safe = this.safes.find((safe) => safe.id === id);
      if (safe) {
        this.activeSafeId = id;
      }
    },

    async depositCoin(amount: string, coin: Coin) {
      const { address } = useConnectionStore();

      const result = await safeService.depositCoin({
        amount,
        coin,
        sender: address,
        safeId: this.activeSafeId!,
      });

      console.log(result);
    },
  },
});
