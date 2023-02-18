<template>
  <PageTextHeader title="Dashboard" />

  <v-row>
    <v-col cols="12" sm="4">
      <v-card border flat height="110">
        <v-card-text>
          <div class="d-flex align-center mb-3">
            <div>Total assets value</div>
          </div>

          <Loading v-if="state.loading" />
          <h5 v-else class="text-h5 font-weight-bold">$ 0</h5>
        </v-card-text>
      </v-card>
    </v-col>

    <v-col cols="12" sm="4">
      <v-card border flat height="110">
        <v-card-text>
          <div class="d-flex align-center mb-3">
            <div>Total coins</div>
            <v-spacer />
            <v-btn
              flat
              class="pa-0 btn-no-active"
              size="small"
              variant="text"
              to="/assets/coins"
            >
              View coins
            </v-btn>
          </div>

          <Loading v-if="state.loading" />
          <h5 v-else class="text-h5 font-weight-bold">
            {{ state.coins.length }}
          </h5>
        </v-card-text>
      </v-card>
    </v-col>

    <v-col cols="12" sm="4">
      <v-card border flat height="110">
        <v-card-text>
          <div class="d-flex align-center mb-3">
            <div>Total NFTs</div>
            <v-spacer />
            <v-btn
              flat
              class="pa-0 btn-no-active"
              size="small"
              variant="text"
              to="/assets/nfts"
            >
              View NFTs
            </v-btn>
          </div>

          <Loading v-if="state.loading" />
          <h5 v-else class="text-h5 font-weight-bold">
            {{ state.nfts.length }}
          </h5>
        </v-card-text>
      </v-card>
    </v-col>
  </v-row>

  <div class="my-12">
    <Empty msg="Hey fren! Nothing to load here for now..." />
  </div>
</template>

<script lang="ts" setup>
import Empty from "@/components/Empty.vue";
import PageTextHeader from "@/components/header/PageTextHeader.vue";
import Loading from "@/components/Loading.vue";
import { Coin, Nft } from "@/lib/types";
import { useSafeStore } from "@/store";
import { storeToRefs } from "pinia";
import { onMounted, reactive } from "vue";
import { useToast } from "vue-toastification";

interface State {
  coins: Coin[];
  nfts: Nft[];
  loading: boolean;
}
const safeStore = useSafeStore();
const { safe } = storeToRefs(safeStore);
const toast = useToast();

const state: State = reactive({ loading: false, coins: [], nfts: [] });

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
  state.coins = safe?.value ? await safe.value.getCoinBalances() : [];
  state.nfts = safe?.value ? await safe.value.getNfts() : [];
}
</script>
