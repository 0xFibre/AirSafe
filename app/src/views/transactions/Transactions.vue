<template>
  <PageTextHeader title="Transactions" />

  <Loading v-if="state.loading" />
  <template v-else>
    <TransactionsList :transactions="transactions" />
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

const safeStore = useSafeStore();
const toast = useToast();
const { transactions } = storeToRefs(safeStore);

const state: { loading: boolean } = reactive({ loading: false });

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
