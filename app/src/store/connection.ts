import { defineStore } from "pinia";
import { useLocalStorage } from "@vueuse/core";
import { connection } from "@/utils";

export const useConnectionStore = defineStore("connection", {
  state: () => ({
    connection: useLocalStorage("connection", {
      address: "",
      wallet: "",
      isConnected: false,
    }),
  }),

  getters: {
    address: (state) => state.connection.address,
    isConnected: (state) => state.connection.isConnected,
    wallet: (state) => state.connection.wallet,
  },

  actions: {
    async establishConnection(wallet: string) {
      await connection.connect(wallet);
      const { account } = connection;

      this.connection = {
        address: account!.address,
        isConnected: true,
        wallet,
      };
    },

    async destroyConnection() {
      await connection.disconnect();
      this.connection = { address: "", isConnected: false, wallet: "" };
    },
  },
});
