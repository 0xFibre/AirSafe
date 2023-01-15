<template>
  <h6 class="text-h6 mb-3 font-weight-bold fonted">Assets</h6>

  <div class="mb-3">
    <v-tabs density="compact" color="primary">
      <v-tab>Coins</v-tab>
    </v-tabs>

    <v-divider />
  </div>

  <template v-if="safe">
    <CoinsTable @deposit="toggleCoinDepositModal" :safe="safe" />
    <CoinDepositModal
      @deposit="coinDeposit"
      @toggle="toggleCoinDepositModal"
      :show="state.coinDeposit.showModal"
      :coin="state.coinDeposit.coin"
    />
  </template>
</template>

<style>
.fonted {
  font-family: Circular, sans-serif !important;
}
</style>

<script lang="ts" setup>
import CoinsTable from "@/components/table/CoinsTable.vue";
import CoinDepositModal from "@/components/modal/CoinDeposit.vue";
import { useSafeStore } from "@/store";
import { storeToRefs } from "pinia";
import { onMounted, reactive } from "vue";
import { Coin } from "@/lib/types";

const safeStore = useSafeStore();
const { safe } = storeToRefs(safeStore);

interface State {
  coinDeposit: {
    coin?: Coin;
    showModal: boolean;
  };
}

const state: State = reactive({
  coinDeposit: {
    showModal: false,
    coin: undefined,
  },
});

onMounted(async () => {
  await safeStore.fetchActiveSafe();
});

function toggleCoinDepositModal(coin?: Coin) {
  state.coinDeposit.showModal = !state.coinDeposit.showModal;
  state.coinDeposit.coin = coin;
}

async function coinDeposit(amount: string, coin: Coin) {
  await safeStore.depositCoin(amount, coin);
}
</script>
