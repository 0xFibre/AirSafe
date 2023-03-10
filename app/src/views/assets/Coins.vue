<template>
  <Loading v-if="state.loading" />
  <template v-else>
    <div class="d-flex my-5 justify-space-between">
      <h6 class="text-h6 font-weight-bold">Coins</h6>

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

    <v-card flat border>
      <CoinsTable
        @deposit="(coin) => toggleModal('deposit', coin)"
        @send="(coin) => toggleModal('send', coin)"
        :coins="state.safeCoins"
      />
    </v-card>

    <DepositCoinModal
      @deposit="depositCoin"
      @toggle="toggleModal('deposit')"
      :show="state.deposit.showModal"
      :coin="state.deposit.coin"
      :coins="state.userCoins"
      :submitting="state.deposit.submitting"
    />

    <SendCoinModal
      @send="sendCoin"
      @toggle="toggleModal('send')"
      :show="state.send.showModal"
      :coin="state.send.coin"
      :coins="state.safeCoins"
      :submitting="state.send.submitting"
    />
  </template>
</template>

<script lang="ts" setup>
import CoinsTable from "@/components/coins/CoinsTable.vue";
import DepositCoinModal from "@/components/coins/DepositCoinModal.vue";
import SendCoinModal from "@/components/coins/SendCoinModal.vue";
import { useConnectionStore, useSafeStore } from "@/store";
import { storeToRefs } from "pinia";
import { onMounted, reactive } from "vue";
import { BasicCoin, Coin } from "@/lib/types";
import { coin } from "@/lib/coin";
import Loading from "@/components/Loading.vue";
import { useToast } from "vue-toastification";
import { useRouter } from "vue-router";

const safeStore = useSafeStore();
const { safe } = storeToRefs(safeStore);

interface State {
  loading: boolean;
  deposit: {
    coin?: BasicCoin;
    showModal: boolean;
    submitting: boolean;
  };
  send: {
    coin?: BasicCoin;
    showModal: boolean;
    submitting: boolean;
  };
  safeCoins: Coin[];
  userCoins: BasicCoin[];
}

const state: State = reactive({
  loading: false,
  deposit: {
    showModal: false,
    submitting: false,
  },
  send: {
    showModal: false,
    submitting: false,
  },
  safeCoins: [],
  userCoins: [],
});

const toast = useToast();
const router = useRouter();
const connectionStore = useConnectionStore();
const { address } = storeToRefs(connectionStore);

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

function toggleModal(action: "deposit" | "send", coin?: BasicCoin) {
  state[action].showModal = !state[action].showModal;
  state[action].coin = coin;
}

async function loadData() {
  await safeStore.fetchActiveSafe();
  state.safeCoins = safe?.value ? await safe.value.getCoinBalances() : [];
  state.userCoins = await coin.getAddressBasicCoins(address.value);
}

async function depositCoin(input: { amount: string; coin: BasicCoin }) {
  try {
    state.deposit.submitting = true;
    await safeStore.depositCoin(input);
    state.deposit.showModal = false;
    await loadData();
  } catch (e) {
    toast.error(e.message);
  } finally {
    state.deposit.submitting = false;
  }
}

async function sendCoin(input: {
  amount: string;
  recipient: string;
  coin: BasicCoin;
}) {
  try {
    state.send.submitting = true;
    const transaction = await safeStore.createCoinWithdrawalTransaction(input);
    state.send.showModal = false;
    router.push({ name: "Transaction", params: { id: transaction.id } });
  } catch (e) {
    toast.error(e.message);
  } finally {
    state.send.submitting = false;
  }
}
</script>
