<template>
  <template v-if="transaction">
    <v-row>
      <v-col cols="12" sm="6">
        <v-card flat border>
          <v-card-text>
            <h6 class="text-body-1 fonted font-weight-bold">
              {{ transaction?.typeValue }}
            </h6>
          </v-card-text>

          <v-divider />

          <v-card-text>
            <div class="my-3 d-flex">
              <span>Amount</span>
              <v-spacer />

              <div class="d-flex align-center">
                {{
                  utils.formatBalance(
                    transaction.input.amount,
                    transaction.coin?.metadata.decimals!
                  )
                }}
                {{ transaction?.coin?.metadata.symbol }}
              </div>
            </div>

            <div class="my-3 d-flex">
              <span>Recipient</span>

              <v-spacer />

              <span>{{
                utils.truncate0x(`0x${transaction.input.recipient}`)
              }}</span>
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" sm="6" md="4">
        <v-card flat border class="mb-3">
          <v-card-text>
            <h6 class="text-body-1 fonted font-weight-bold">Information</h6>
          </v-card-text>

          <v-divider />

          <v-card-text>
            <div class="my-3 d-flex">
              <span>Creator</span>

              <v-spacer />

              <span>
                {{ utils.truncate0x(transaction.creator) }}
              </span>
            </div>

            <div class="my-3 d-flex">
              <span>Type</span>
              <v-spacer />
              <span>{{ transaction.typeValue }}</span>
            </div>

            <div class="my-3 d-flex">
              <span>Status</span>
              <v-spacer />
              <span>{{ transaction.statusValue }}</span>
            </div>
          </v-card-text>
        </v-card>

        <v-card flat border>
          <v-card-text>
            <h6 class="text-body-1 fonted font-weight-bold">Approvals</h6>
          </v-card-text>

          <v-divider />

          <v-card-text>
            <div class="d-flex">
              <v-btn flat class="me-1" color="success">Approve</v-btn>
              <v-btn flat class="ms-1" color="error">Reject</v-btn>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </template>
</template>

<script lang="ts" setup>
import { useSafeStore, useTransactionStore } from "@/store";
import { storeToRefs } from "pinia";
import { onMounted } from "vue";
import { utils } from "@/utils";
import { useRoute } from "vue-router";

const route = useRoute();
const safeStore = useSafeStore();
const transactionStore = useTransactionStore();
const { transaction } = storeToRefs(transactionStore);

onMounted(async () => {
  await safeStore.fetchActiveSafe();
  await transactionStore.fetchTransaction(<string>route.params.id);
});
</script>

<style scoped>
.fonted {
  font-family: Circular, sans-serif !important;
}
</style>
