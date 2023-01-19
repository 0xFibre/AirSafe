<template>
  <PageTextHeader title="Dashboard" />

  <v-row>
    <v-col cols="12" sm="4">
      <v-card flat height="100">
        <v-card-text>
          <div class="d-flex align-center mb-3">
            <div>Total assets value</div>
          </div>

          <h5 class="text-h5 font-weight-bold">$ 0</h5>
        </v-card-text>
      </v-card>
    </v-col>

    <v-col cols="12" sm="4">
      <v-card flat height="100">
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

          <h5 class="text-h5 font-weight-bold">{{ state.coins.length }}</h5>
        </v-card-text>
      </v-card>
    </v-col>

    <v-col cols="12" sm="4">
      <v-card flat height="100">
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

          <h5 class="text-h5 font-weight-bold">{{ state.nfts.length }}</h5>
        </v-card-text>
      </v-card>
    </v-col>
  </v-row>
</template>

<script lang="ts" setup>
import PageTextHeader from "@/components/header/PageTextHeader.vue";
import { Coin, Nft } from "@/lib/types";
import { useSafeStore } from "@/store";
import { storeToRefs } from "pinia";
import { onMounted, reactive } from "vue";

const safeStore = useSafeStore();
const { safe } = storeToRefs(safeStore);

interface State {
  coins: Coin[];
  nfts: Nft[];
}

const state: State = reactive({ coins: [], nfts: [] });
onMounted(async () => {
  await loadData();
});

async function loadData() {
  await safeStore.fetchActiveSafe();
  state.coins = safe?.value ? await safe.value.getCoinBalances() : [];
  state.nfts = safe?.value ? await safe.value.getNfts() : [];
}
</script>
