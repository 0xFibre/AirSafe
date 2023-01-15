<template>
  <template v-if="safe">
    <div class="d-flex mt-5">
      <h6 class="text-h6 mb-3 font-weight-bold fonted">Coins</h6>

      <v-spacer />

      <v-btn
        flat
        append-icon="mdi-arrow-down"
        variant="tonal"
        color="primary"
        class="me-1"
      >
        Deposit
      </v-btn>
    </div>

    <v-card flat>
      <CoinsTable
        @deposit="toggleCoinDepositModal"
        @transfer="toggleCoinTransferModal"
        :safe="safe"
      />
    </v-card>

    <CoinDepositModal
      @deposit="coinDeposit"
      @toggle="toggleCoinDepositModal"
      :show="state.coinDeposit.showModal"
      :coin="state.coinDeposit.coin"
    />

    <CoinTransferModal
      @transfer="createCoinTransfer"
      @toggle="toggleCoinTransferModal"
      :show="state.coinTransfer.showModal"
      :coin="state.coinTransfer.coin"
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
import CoinTransferModal from "@/components/modal/CoinTransfer.vue";
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
  coinTransfer: {
    coin?: Coin;
    showModal: boolean;
  };
}

const state: State = reactive({
  coinDeposit: {
    showModal: false,
    coin: undefined,
  },
  coinTransfer: {
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

function toggleCoinTransferModal(coin?: Coin) {
  state.coinTransfer.showModal = !state.coinTransfer.showModal;
  state.coinTransfer.coin = coin;
}

async function coinDeposit(amount: string, coin: Coin) {
  await safeStore.depositCoin(amount, coin);
}

async function createCoinTransfer(
  input: {
    amount: string;
    recipient: string;
  },
  coin: Coin
) {
  await safeStore.createCoinTransfer(input, coin);
}
</script>
