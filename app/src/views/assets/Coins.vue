<template>
  <template v-if="safe">
    <div class="d-flex my-5">
      <h6 class="text-h6 font-weight-bold fonted">Coins</h6>

      <v-spacer />

      <v-btn
        flat
        append-icon="mdi-arrow-down"
        variant="tonal"
        color="primary"
        class="me-1"
        @click="toggleModal('deposit')"
      >
        Deposit
      </v-btn>
    </div>

    <v-card flat>
      <CoinsTable
        @deposit="toggleModal('deposit')"
        @send="toggleModal('send')"
        :coins="state.safeCoins"
      />
    </v-card>

    <CoinDepositModal
      @deposit="depositCoin"
      @toggle="toggleModal('deposit')"
      :show="state.deposit.showModal"
      :coin="state.deposit.coin"
      :coins="state.userCoins"
    />

    <CoinSendModal
      @send="sendCoin"
      @toggle="toggleModal('send')"
      :show="state.send.showModal"
      :coin="state.send.coin"
      :coins="state.safeCoins"
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
import CoinSendModal from "@/components/modal/CoinSend.vue";
import { useConnectionStore, useSafeStore } from "@/store";
import { storeToRefs } from "pinia";
import { onMounted, reactive } from "vue";
import { BasicCoin, Coin } from "@/lib/types";
import { coin } from "@/lib/coin";

const safeStore = useSafeStore();
const { safe } = storeToRefs(safeStore);

interface State {
  deposit: {
    coin?: BasicCoin;
    showModal: boolean;
  };
  send: {
    coin?: BasicCoin;
    showModal: boolean;
  };
  safeCoins: Coin[];
  userCoins: BasicCoin[];
}

const state: State = reactive({
  deposit: {
    showModal: false,
    coin: undefined,
  },
  send: {
    showModal: false,
    coin: undefined,
  },
  safeCoins: [],
  userCoins: [],
});

const connectionStore = useConnectionStore();
const { address } = storeToRefs(connectionStore);

onMounted(async () => {
  await safeStore.fetchActiveSafe();
  state.safeCoins = safe?.value ? await safe.value.getCoinBalances() : [];
  state.userCoins = await coin.getAddressBasicCoins(address.value);
});

function toggleModal(action: "deposit" | "send", coin?: BasicCoin) {
  state[action].showModal = !state[action].showModal;
  state[action].coin = coin;
}

async function depositCoin(input: { amount: string; coin: BasicCoin }) {
  await safeStore.depositCoin(input);
}

async function sendCoin(input: {
  amount: string;
  recipient: string;
  coin: Coin;
}) {
  await safeStore.createCoinWithdrawalTransaction(input);
}
</script>