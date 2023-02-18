<template>
  <Loading v-if="state.loading" />
  <v-row v-else>
    <v-col cols="12" sm="8" md="6" class="mx-auto">
      <PageTextHeader title="New transaction" />

      <v-card flat border>
        <v-card-text>
          <div class="mb-3">
            <p class="text-body-2 mb-3">Select transaction type</p>
            <v-select
              :items="types"
              color="primary"
              density="compact"
              variant="outlined"
              v-model="state.input.type"
              hide-details
            />
          </div>

          <WithdrawCoinInput
            v-if="
              state.input.type ==
              safeTransactionTypeValue[SafeTransactionType.COIN_WITHDRAWAL]
            "
            @change="
              (key, value) => updateInputData('withdrawCoin', key, value)
            "
            :coins="state.coins"
          />

          <WithdrawAssetInput
            v-if="
              state.input.type ==
              safeTransactionTypeValue[SafeTransactionType.ASSET_WITHDRAWAL]
            "
            @change="(key, value) => updateInputData('withdrawNft', key, value)"
            :nfts="state.nfts"
          />

          <v-btn
            flat
            block
            color="primary"
            @click="createTransaction"
            :disabled="state.submitting"
          >
            Submit
          </v-btn>
        </v-card-text>
      </v-card>
    </v-col>
  </v-row>
</template>

<script lang="ts" setup>
import PageTextHeader from "@/components/header/PageTextHeader.vue";
import {
  safeTransactionTypeValue,
  SafeTransactionType,
  BasicCoin,
  Nft,
} from "@/lib/types";
import WithdrawCoinInput from "./new/WithdrawCoinInput.vue";
import WithdrawAssetInput from "./new/WithdrawAssetInput.vue";
import { onMounted, reactive } from "vue";
import { useSafeStore } from "@/store";
import { storeToRefs } from "pinia";
import { useToast } from "vue-toastification";
import Loading from "@/components/Loading.vue";
import { SafeTransaction } from "@/lib/entity";
import { useRouter } from "vue-router";

interface State {
  input: {
    type: string;
    withdrawCoin: {
      amount: string;
      recipient: string;
      coin?: BasicCoin;
    };
    withdrawNft: {
      recipient: string;
      nft?: Nft;
    };
  };
  loading: boolean;
  submitting: boolean;
  coins: BasicCoin[];
  nfts: Nft[];
}

const toast = useToast();
const router = useRouter();
const safeStore = useSafeStore();
const { safe } = storeToRefs(safeStore);
const state: State = reactive({
  input: {
    type: "",
    withdrawCoin: { amount: "", recipient: "" },
    withdrawNft: { recipient: "" },
  },
  loading: false,
  submitting: false,
  coins: [],
  nfts: [],
});

const types = [
  safeTransactionTypeValue[SafeTransactionType.COIN_WITHDRAWAL],
  safeTransactionTypeValue[SafeTransactionType.ASSET_WITHDRAWAL],
];

onMounted(async () => {
  try {
    state.loading = true;
    await loadData();
  } catch (e) {
    toast.error(e.message);
  } finally {
    state.loading = false;
  }
});

async function loadData() {
  await safeStore.fetchActiveSafe();

  state.coins = safe?.value ? await safe.value.getCoinBalances() : [];
  state.nfts = safe?.value ? await safe.value.getNfts() : [];
}

function updateInputData(
  type: "withdrawCoin" | "withdrawNft",
  key: string,
  value: any
) {
  // @ts-expect-error
  state.input[type][key] = value;
}

async function createTransaction() {
  try {
    state.submitting = true;

    if (
      state.input.type ==
      safeTransactionTypeValue[SafeTransactionType.COIN_WITHDRAWAL]
    ) {
      if (state.input.withdrawCoin.coin) {
        const transaction = await safeStore.createCoinWithdrawalTransaction({
          ...state.input.withdrawCoin,
          coin: state.input.withdrawCoin.coin,
        });

        router.push({ name: "Transaction", params: { id: transaction.id } });
      }
    } else if (
      state.input.type ==
      safeTransactionTypeValue[SafeTransactionType.ASSET_WITHDRAWAL]
    ) {
      if (state.input.withdrawNft.nft) {
        const transaction = await safeStore.createNftWithdrawalTransaction({
          ...state.input.withdrawNft,
          nft: state.input.withdrawNft.nft,
        });

        router.push({ name: "Transaction", params: { id: transaction.id } });
      }
    }
  } catch (e) {
    toast.error(e.message);
  } finally {
    state.submitting = false;
  }
}
</script>
