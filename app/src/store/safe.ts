import { Safe } from "@/lib/entity";
import { safeService } from "@/lib/service";
import { useLocalStorage } from "@vueuse/core";
import { defineStore } from "pinia";
import { useConnectionStore } from "./connection";

export const useSafeStore = defineStore("safe", {
  state: () =>
    <{ safes: Safe[]; activeSafe: string | null }>{
      safes: [],
      activeSafe: <string | null>(<unknown>useLocalStorage("activeSafe", null)),
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

    async setActiveSafe(id: string) {
      const safe = this.safes.find((safe) => safe.id === id);
      if (safe) {
        this.activeSafe = id;
      }
    },
  },
});
