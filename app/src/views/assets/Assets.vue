<template>
  <h5 class="text-h5 font-weight-bold fonted">Assets</h5>

  <div class="mb-3">
    <v-tabs color="primary">
      <v-tab>Coins</v-tab>
    </v-tabs>

    <v-divider />
  </div>

  <template v-if="safe">
    <CoinsTable @deposit="toggleDepositModal" :safe="safe" />
    <CoinDepositModal
      @deposit="coinDeposit"
      @toggle="toggleDepositModal"
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

function toggleDepositModal(coin?: Coin) {
  state.coinDeposit.showModal = !state.coinDeposit.showModal;
  state.coinDeposit.coin = coin;
}

async function coinDeposit(amount: string, coin: Coin) {
  await safeStore.depositCoin(amount, coin);
}
</script>
