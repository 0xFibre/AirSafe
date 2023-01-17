<template>
  <div class="my-5">
    <h6 class="text-h6 font-weight-bold fonted">Transaction</h6>
  </div>

  <Loading v-if="state.loading" />
  <template v-else>
    <v-row v-if="transaction" justify="space-around">
      <v-col cols="12" sm="6" md="7">
        <v-card flat class="mb-3">
          <v-card-text>
            <h6 class="text-body-1 fonted font-weight-bold">
              {{ transaction?.typeValue }}
            </h6>
          </v-card-text>

          <v-divider />

          <v-card-text v-if="transaction.coin">
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

        <v-card flat>
          <v-card-text class="d-flex">
            <h6 class="text-body-1 fonted font-weight-bold">Approvers</h6>
            <v-spacer />
            <v-btn
              density="comfortable"
              flat
              icon="mdi-chevron-down"
              @click="toggleExpansion('approvers')"
            />
          </v-card-text>

          <v-divider />

          <v-expand-transition>
            <div v-show="state.approvers.show">
              <v-card-text>
                <v-list>
                  <v-list-item
                    v-for="address in transaction.approvers"
                    :prepend-avatar="makeBlockie(address)"
                    :key="address"
                  >
                    <v-list-item-title>{{ address }}</v-list-item-title>

                    <template v-slot:append>
                      <v-btn
                        flat
                        variant="text"
                        icon="mdi-open-in-new"
                        size="small"
                      />
                    </template>
                  </v-list-item>
                </v-list>
              </v-card-text>
            </div>
          </v-expand-transition>
        </v-card>
      </v-col>

      <v-col cols="12" sm="6" md="5">
        <v-card flat class="mb-3">
          <v-card-text>
            <h6 class="text-body-1 fonted font-weight-bold">Info</h6>
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

        <v-card flat>
          <v-card-text>
            <h6 class="text-body-1 fonted font-weight-bold">Status</h6>
          </v-card-text>

          <v-divider />

          <v-card-text>
            <div class="my-3 d-flex">
              <span>Approvals</span>

              <v-spacer />

              <span>
                {{ transaction.approvers.length }}
              </span>
            </div>

            <div class="my-3 d-flex">
              <span>Rejections</span>

              <v-spacer />

              <span>
                {{ transaction.rejecters.length }}
              </span>
            </div>

            <div class="my-3 d-flex">
              <span>Confirmations</span>

              <v-spacer />

              <span>
                {{ transaction.approvers.length }} of
                {{ safe ? safe.threshold : "" }}
              </span>
            </div>

            <div class="d-flex mt-5" v-if="transaction.status == 1">
              <v-btn
                flat
                class="me-1"
                color="success"
                @click="approveSafeTransaction"
                >Approve</v-btn
              >
              <v-btn
                flat
                class="ms-1"
                color="error"
                @click="rejectSafeTransaction"
                >Reject</v-btn
              >
            </div>
            <v-btn
              v-else-if="transaction.status == 2"
              flat
              block
              class="mt-5"
              color="primary"
              @click="executeSafeTransaction"
            >
              Execute
            </v-btn>

            <v-btn
              v-else-if="transaction.status == 3 || transaction.status == 4"
              flat
              block
              class="mt-5"
              variant="outlined"
              disabled
              :color="transaction.status == 3 ? 'error' : 'success'"
            >
              {{ transaction.statusValue }}
            </v-btn>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </template>
</template>

<script lang="ts" setup>
import { useSafeStore, useTransactionStore } from "@/store";
import { storeToRefs } from "pinia";
import { onMounted, reactive } from "vue";
import { utils } from "@/utils";
import { useRoute } from "vue-router";
import makeBlockie from "ethereum-blockies-base64";
import { SafeTransactionType } from "@/lib/types";
import Loading from "@/components/Loading.vue";

const route = useRoute();
const safeStore = useSafeStore();
const transactionStore = useTransactionStore();
const { safe } = storeToRefs(safeStore);
const { transaction } = storeToRefs(transactionStore);

interface State {
  loading: boolean;
  approvers: {
    show: boolean;
  };
}
const state: State = reactive({
  loading: false,
  approvers: {
    show: true,
  },
});

onMounted(async () => {
  try {
    state.loading = true;
    await safeStore.fetchActiveSafe();
    await transactionStore.fetchTransaction(<string>route.params.id);
  } catch (e) {
    console.log(e);
  } finally {
    state.loading = false;
  }
});

async function approveSafeTransaction() {
  await safeStore.approveTransaction(<string>route.params.id);
}

async function rejectSafeTransaction() {
  await safeStore.rejectTransaction(<string>route.params.id);
}

async function executeSafeTransaction() {
  switch (transaction?.value?.type) {
    case SafeTransactionType.COIN_WITHDRAWAL:
      await safeStore.executeCoinWithdrawal(
        <string>route.params.id,
        transaction.value.coin!
      );
      break;
    case SafeTransactionType.ADD_OWNER:
    case SafeTransactionType.REMOVE_OWNER:
    case SafeTransactionType.CHANGE_THRESHOLD:
      await safeStore.executePolicyChange(<string>route.params.id);
  }
}

function toggleExpansion(s: string) {
  state.approvers.show = !state.approvers.show;
}
</script>
