<template>
  <div class="my-5">
    <h6 class="text-h6 font-weight-bold fonted">Transactions</h6>
  </div>

  <v-table>
    <tbody>
      <template v-for="(transaction, i) in transactions" :key="i">
        <tr>
          <td>
            <div class="mb-2 mb-sm-0">
              <v-btn
                flat
                variant="text"
                color="primary"
                density="compact"
                append-icon="mdi-arrow-top-right"
              >
                {{ utils.truncate0x(transaction.id) }}
              </v-btn>
            </div>
          </td>
          <td>
            <div class="mb-2 mb-sm-0">
              {{ transaction.typeValue }}
            </div>
          </td>
          <td>
            <div
              v-if="transaction.coin"
              class="mb-2 mb-sm-0 d-flex align-start align-sm-center"
            >
              <v-avatar size="20" class="me-2">
                <v-img :src="transaction.coin.metadata.iconUrl" />
              </v-avatar>

              <div class="mb-2 mb-sm-0">
                {{
                  utils.formatBalance(
                    transaction.input.amount,
                    transaction.coin.metadata.decimals
                  )
                }}
                {{ transaction.coin.metadata.symbol }}
              </div>
            </div>
          </td>
          <td>
            <div class="mb-2 mb-sm-0">
              <v-chip
                label
                density="comfortable"
                :color="
                  transaction.status == 1
                    ? 'primary'
                    : transaction.status == 2
                    ? 'success'
                    : transaction.status == 3
                    ? 'error'
                    : transaction.status == 4
                    ? 'success'
                    : ''
                "
              >
                {{ transaction.statusValue }}
              </v-chip>
            </div>
          </td>
          <td>
            <div class="mb-2 mb-sm-0 align-self-end">
              <v-btn
                flat
                variant="text"
                color="primary"
                density="compact"
                append-icon="mdi-arrow-right"
                :to="`/transaction/${transaction.id}`"
              >
                open
              </v-btn>
            </div>
          </td>
        </tr>
      </template>
    </tbody>
  </v-table>

  <Empty
    v-if="transactions.length < 1"
    msg="You do not have any transactions yet"
  />
</template>

<script lang="ts" setup>
import { useSafeStore, useTransactionStore } from "@/store";
import { storeToRefs } from "pinia";
import { onMounted } from "vue";
import { utils } from "@/utils";
import Empty from "@/components/Empty.vue";

const safeStore = useSafeStore();
const transactionStore = useTransactionStore();
const { transactions } = storeToRefs(transactionStore);

onMounted(async () => {
  await safeStore.fetchActiveSafe();
  await transactionStore.fetchTransactions();
});
</script>

<style scoped>
.fonted {
  font-family: Circular, sans-serif !important;
}
</style>