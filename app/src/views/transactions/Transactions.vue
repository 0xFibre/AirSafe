<template>
  <PageTextHeader title="Transactions" />

  <Loading v-if="state.loading" />

  <template v-else>
    <div class="mb-5">
      <v-tabs v-model="state.tab">
        <v-tab :value="tab" v-for="tab in state.tabs">{{ tab }}</v-tab>
      </v-tabs>
      <v-divider />
    </div>

    <v-window v-model="state.tab">
      <v-window-item :value="tab" v-for="tab in state.tabs">
        <TransactionsList
          :transactions="
            tab == 'All'
              ? transactions
              : transactions.filter((tx) => tx.statusValue == tab)
          "
        />
      </v-window-item>
    </v-window>

    <Empty v-if="transactions.length < 1" msg="Ooopss... No transactions yet" />
  </template>
</template>

<script lang="ts" setup>
import { useSafeStore } from "@/store";
import { storeToRefs } from "pinia";
import { onMounted, reactive } from "vue";
import Empty from "@/components/Empty.vue";
import Loading from "@/components/Loading.vue";
import PageTextHeader from "@/components/header/PageTextHeader.vue";
import TransactionsList from "@/components/transactions/TransactionsList.vue";
import { useToast } from "vue-toastification";
import { SafeTransactionStatus, safeTransactionStatusValue } from "@/lib/types";

const safeStore = useSafeStore();
const toast = useToast();
const { transactions } = storeToRefs(safeStore);

const state: {
  tab: number | null;
  tabs: any[];
  loading: boolean;
} = reactive({
  tab: null,
  tabs: [
    "All",
    safeTransactionStatusValue[SafeTransactionStatus.PENDING],
    safeTransactionStatusValue[SafeTransactionStatus.APPROVED],
    safeTransactionStatusValue[SafeTransactionStatus.REJECTED],
    safeTransactionStatusValue[SafeTransactionStatus.EXECUTED],
  ],
  loading: false,
});

onMounted(async () => {
  try {
    state.loading = true;
    await safeStore.fetchActiveSafe();
    await safeStore.fetchTransactions();
  } catch (e) {
    toast.error(e.message);
  } finally {
    state.loading = false;
  }
});
</script>
