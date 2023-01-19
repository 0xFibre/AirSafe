<template>
  <PageTextHeader title="Transaction" />

  <Loading v-if="state.loading" />
  <template v-else>
    <v-row v-if="transaction" justify="space-around">
      <v-col cols="12" sm="6" md="7">
        <TransactionDataCard :transaction="transaction" />

        <template v-for="action in Object.keys(state.expansion)">
          <TransactionActorsCard
            :action="action"
            :data="transaction[<keyof State['expansion']>action]"
            :show="state.expansion[<keyof State['expansion']>action ] "
            @toggle="toggleExpansion(<keyof State['expansion']>action)"
          />
        </template>
      </v-col>

      <v-col cols="12" sm="6" md="5">
        <TransactionInfoCard :transaction="transaction" />
        <TransactionStatusCard
          :transaction="transaction"
          :safe="safe!"
          :address="address"
          @approve="approveSafeTransaction"
          @reject="rejectSafeTransaction"
          @execute="executeSafeTransaction"
        />
      </v-col>
    </v-row>
  </template>
</template>

<script lang="ts" setup>
import { useConnectionStore, useSafeStore } from "@/store";
import { storeToRefs } from "pinia";
import { onMounted, reactive } from "vue";
import { useRoute } from "vue-router";
import { SafeTransactionType } from "@/lib/types";
import Loading from "@/components/Loading.vue";
import PageTextHeader from "@/components/header/PageTextHeader.vue";
import TransactionDataCard from "@/components/transactions/TransactionDataCard.vue";
import TransactionActorsCard from "@/components/transactions/TransactionActorsCard.vue";
import TransactionInfoCard from "@/components/transactions/TransactionInfoCard.vue";
import TransactionStatusCard from "@/components/transactions/TransactionStatusCard.vue";
import { useToast } from "vue-toastification";

const route = useRoute();
const safeStore = useSafeStore();
const connectionStore = useConnectionStore();
const { safe, transaction } = storeToRefs(safeStore);
const { address } = storeToRefs(connectionStore);

interface State {
  loading: boolean;
  expansion: {
    approvers: boolean;
    rejecters: boolean;
  };
}

const toast = useToast();
const state: State = reactive({
  loading: false,
  expansion: {
    approvers: true,
    rejecters: true,
  },
});

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
  await safeStore.fetchTransaction(<string>route.params.id);
}

async function approveSafeTransaction() {
  try {
    await safeStore.approveTransaction(<string>route.params.id);
    await loadData();
  } catch (e) {
    toast.error(e.message);
  }
}

async function rejectSafeTransaction() {
  try {
    await safeStore.rejectTransaction(<string>route.params.id);
    await loadData();
  } catch (e) {
    toast.error(e.message);
  }
}

async function executeSafeTransaction() {
  try {
    switch (transaction?.value?.type) {
      case SafeTransactionType.COIN_WITHDRAWAL:
        await safeStore.executeCoinWithdrawal(
          <string>route.params.id,
          transaction.value.coin!
        );
        break;
      case SafeTransactionType.ASSET_WITHDRAWAL:
        await safeStore.executeAssetWithdrawal(
          <string>route.params.id,
          transaction.value.input.assetType
        );
        break;
      case SafeTransactionType.ADD_OWNER:
      case SafeTransactionType.REMOVE_OWNER:
      case SafeTransactionType.CHANGE_THRESHOLD:
        await safeStore.executePolicyChange(<string>route.params.id);
    }

    await loadData();
  } catch (e) {
    toast.error(e.message);
  }
}

function toggleExpansion(s: keyof State["expansion"]) {
  state.expansion[s] = !state.expansion[s];
}
</script>
