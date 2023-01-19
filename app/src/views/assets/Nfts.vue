<template>
  <Loading v-if="state.loading" />
  <template v-else>
    <div class="d-flex my-5 justify-space-between">
      <h6 class="text-h6 font-weight-bold">Nfts</h6>

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

    <NftsList
      @send="(nft) => toggleModal('send', nft)"
      :nfts="state.safeNfts"
    />

    <DepositNftModal
      @deposit="depositNft"
      @toggle="toggleModal('deposit')"
      :show="state.deposit.showModal"
      :nfts="state.userNfts"
    />

    <SendNftModal
      @send="sendNft"
      @toggle="toggleModal('send')"
      :show="state.send.showModal"
      :nft="state.send.nft"
    />
  </template>
</template>

<script lang="ts" setup>
import NftsList from "@/components/nfts/NftsList.vue";
import DepositNftModal from "@/components/nfts/DepositNftModal.vue";
import SendNftModal from "@/components/nfts/SendNftModal.vue";
import { useConnectionStore, useSafeStore } from "@/store";
import { storeToRefs } from "pinia";
import { onMounted, reactive } from "vue";
import Loading from "@/components/Loading.vue";
import { nft } from "@/lib/nft";
import { Nft } from "@/lib/types";
import { useToast } from "vue-toastification";

const toast = useToast();
const safeStore = useSafeStore();
const { safe } = storeToRefs(safeStore);

interface State {
  loading: boolean;
  deposit: {
    showModal: boolean;
  };
  send: {
    nft?: Nft;
    showModal: boolean;
  };
  safeNfts: Nft[];
  userNfts: Nft[];
}

const state: State = reactive({
  loading: false,
  deposit: {
    showModal: false,
  },
  send: {
    showModal: false,
  },
  safeNfts: [],
  userNfts: [],
});

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

function toggleModal(action: "deposit" | "send", nft?: Nft) {
  state[action].showModal = !state[action].showModal;
  if (action == "send") state[action].nft = nft;
}

async function loadData() {
  await safeStore.fetchActiveSafe();
  state.safeNfts = safe?.value ? await safe.value.getNfts() : [];
  state.userNfts = await nft.getAddressNfts(address.value);
}

async function depositNft(input: { nft: Nft }) {
  try {
    await safeStore.depositNft(input);
    state.deposit.showModal = false;
    await loadData();
  } catch (e) {
    toast.error(e);
  }
}

async function sendNft(input: { recipient: string; nft: Nft }) {
  try {
    await safeStore.createNftWithdrawalTransaction(input);
    state.send.showModal = false;
    await loadData();
  } catch (e) {
    toast.error(e);
  }
}
</script>
