import { Safe, SafeTransaction } from "@/lib/entity";
import { response } from "@/lib/response";
import { serializer } from "@/lib/serializer";
import { safeService } from "@/lib/service";
import {
  BasicCoin,
  Nft,
  SafeTransactionType,
  safeTransactionTypeData,
} from "@/lib/types";
import { utils } from "@/utils";
import { useLocalStorage } from "@vueuse/core";
import { defineStore } from "pinia";
import { useConnectionStore } from "./connection";

interface SafeStore {
  safes: Safe[];
  safe?: Safe;
  activeSafeId: string | null;
  transactions: SafeTransaction[];
  transaction?: SafeTransaction;
  safeNames: Record<string, string>;
}

const textEncoder = new TextEncoder();

export const useSafeStore = defineStore("safe", {
  state: () =>
    <SafeStore>{
      safes: [],
      activeSafeId: <string | null>(
        (<unknown>useLocalStorage("activeSafeId", null))
      ),
      safe: undefined,
      transactions: [],
      transaction: undefined,
      safeNames: <Record<string, string>>(
        (<unknown>useLocalStorage("safeNames", {}))
      ),
    },

  getters: {
    safeName: (state) => (safeId: string) => state.safeNames[safeId],
  },

  actions: {
    async createSafe(data: {
      name: string;
      threshold: string;
      owners: string[];
    }) {
      const result = await safeService.createSafe({
        threshold: data.threshold,
        owners: data.owners,
      });

      if (result) {
        const transaction = response.validateSuiTransactionResponse(result);
        const { reference: ref } = transaction.effects.created![0];
        const safe = await safeService.getSafe(ref.objectId);

        this.safes = [...this.safes, safe];
        this.setSafeName(safe.id, data.name);
        await this.setActiveSafeId(safe.id);

        return safe;
      }

      throw new Error(`Error: Unable to send transaction`);
    },

    setSafeName(safeId: string, name: string) {
      this.safeNames[safeId] = name;
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
      if (!safe) {
        throw new Error(`Safe not found`);
      }

      this.activeSafeId = id;
    },

    async depositCoin(input: { amount: string; coin: BasicCoin }) {
      const { address } = useConnectionStore();

      return await safeService.depositCoin({
        amount: input.amount,
        coin: input.coin,
        sender: address,
        safeId: this.activeSafeId!,
      });
    },

    async depositNft(input: { nft: Nft }) {
      return await this.depositAsset(input.nft.type, input.nft.id);
    },

    async depositAsset(assetType: string, assetId: string) {
      return await safeService.depositAsset({
        assetType,
        assetId,
        safeId: this.activeSafeId!,
      });
    },

    async createTransaction(type: SafeTransactionType, data: string) {
      const result = await safeService.createTransaction({
        data,
        type,
        safeId: this.activeSafeId!,
      });

      if (result) {
        const transaction = response.validateSuiTransactionResponse(result);
        const { reference: ref } = transaction.effects.created![0];
        const tx = await safeService.getSafeTransaction(ref.objectId);

        this.transactions = [...this.transactions, tx];
        return tx;
      }

      throw new Error(`Error: Unable to send transaction`);
    },

    async createCoinWithdrawalTransaction(input: {
      amount: string;
      recipient: string;
      coin: BasicCoin;
    }) {
      const amount = utils
        .parseBalance(input.amount, input.coin.metadata.decimals)
        .toString();

      const data = serializer.serialize(
        safeTransactionTypeData[SafeTransactionType.COIN_WITHDRAWAL],
        {
          coin_type: Uint8Array.from(textEncoder.encode(input.coin.coinType)),
          amount: amount,
          recipient: input.recipient,
        }
      );

      return await this.createTransaction(
        SafeTransactionType.COIN_WITHDRAWAL,
        data
      );
    },

    async createNftWithdrawalTransaction(input: {
      recipient: string;
      nft: Nft;
    }) {
      const withdrawalData = serializer.serialize(
        safeTransactionTypeData[SafeTransactionType.ASSET_WITHDRAWAL],
        {
          asset_id: input.nft.id,
          asset_type: Uint8Array.from(new TextEncoder().encode(input.nft.type)),
          recipient: input.recipient,
        }
      );

      return await this.createAssetWithdrawalTransaction(withdrawalData);
    },

    async createAssetWithdrawalTransaction(data: string) {
      return await this.createTransaction(
        SafeTransactionType.ASSET_WITHDRAWAL,
        data
      );
    },

    async manageOwnerTransaction(input: {
      type: "add" | "remove";
      owner: string;
      threshold: string;
    }) {
      let data: string, type: SafeTransactionType;
      switch (input.type) {
        case "add":
          type = SafeTransactionType.ADD_OWNER;
          data = serializer.serialize(safeTransactionTypeData[type], {
            owner: input.owner,
            threshold: input.threshold,
          });
          break;
        case "remove":
          type = SafeTransactionType.REMOVE_OWNER;
          data = serializer.serialize(safeTransactionTypeData[type], {
            owner: input.owner,
            threshold: input.threshold,
          });
          break;
        default:
          throw new Error("Invalid owner management type");
      }

      return await this.createTransaction(type, data);
    },

    async changeThresholdTransaction(threshold: string) {
      const data = serializer.serialize(
        safeTransactionTypeData[SafeTransactionType.CHANGE_THRESHOLD],
        { threshold }
      );

      return await this.createTransaction(
        SafeTransactionType.CHANGE_THRESHOLD,
        data
      );
    },

    async approveTransaction(transactionId: string) {
      return await safeService.approveTransaction({
        transactionId,
        safeId: this.activeSafeId!,
      });
    },

    async rejectTransaction(transactionId: string) {
      return await safeService.rejectTransaction({
        transactionId,
        safeId: this.activeSafeId!,
      });
    },

    // Transaction execution functions

    async executeCoinWithdrawal(transactionId: string, coin: BasicCoin) {
      return await safeService.executeCoinWithdrawal({
        transactionId,
        safeId: this.activeSafeId!,
        coin,
      });
    },

    async executeAssetWithdrawal(transactionId: string, assetType: string) {
      return await safeService.executeAssetWithdrawal({
        transactionId,
        safeId: this.activeSafeId!,
        assetType,
      });
    },

    async executePolicyChange(transactionId: string) {
      return await safeService.executePolicyChange({
        transactionId,
        safeId: this.activeSafeId!,
      });
    },

    // transactions fetch functions

    async fetchTransactions() {
      const { safe } = useSafeStore();
      this.transactions = await safeService.getSafeTransactions(
        safe?.transactions!
      );
    },

    async fetchTransaction(id: string) {
      this.transaction = await safeService.getSafeTransaction(id);
    },
  },
});
