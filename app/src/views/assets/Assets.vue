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
    <CoinDepositModal @deposit="depositCoin" :show="state.depositCoin.show" />
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
import { Safe } from "@/lib/entity";

const safeStore = useSafeStore();
const { safe } = storeToRefs(safeStore);

interface State {
  depositCoin: {
    show: boolean;
    coin?: string;
  };
}

const state: State = reactive({
  depositCoin: {
    show: false,
    coin: undefined,
  },
});

onMounted(async () => {
  await safeStore.fetchActiveSafe();
});

function toggleDepositModal(coin?: { type: string }) {
  state.depositCoin.show = !state.depositCoin.show;
  state.depositCoin.coin = coin?.type;
}

async function depositCoin(data: { amount: string }) {
  let payload = { amount: data.amount, coinType: "0x2::sui::SUI" };
  await safeStore.depositCoin(payload.amount, payload.coinType);
}
</script>
