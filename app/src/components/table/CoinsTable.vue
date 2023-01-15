<template>
  <v-table hover fixed-header>
    <thead>
      <tr>
        <th>Name</th>
        <th>Balance</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="coin in state.coins" :key="coin.id">
        <td>
          <v-avatar size="30" class="me-3">
            <v-img
              :src="
                coin.metadata.iconUrl
                  ? coin.metadata.iconUrl
                  : coin.coinType === '0x2::sui::SUI'
                  ? '/assets/sui.svg'
                  : ''
              "
            />
          </v-avatar>

          {{ coin.metadata.name }}
        </td>
        <td>
          {{ utils.formatBalance(coin.balance, coin.metadata.decimals) }}
          {{ coin.metadata.symbol }}
        </td>
        <td class="text-right">
          <v-btn
            flat
            color="black"
            variant="tonal"
            class="me-1"
            density="comfortable"
            prepend-icon="mdi-arrow-bottom-left"
            @click="$emit('deposit', coin)"
          >
            Deposit
          </v-btn>
          <v-btn
            flat
            color="black"
            variant="tonal"
            class="ms-1"
            density="comfortable"
            append-icon="mdi-arrow-top-right"
          >
            Send
          </v-btn>
        </td>
      </tr>
    </tbody>
  </v-table>

  <Empty v-if="state.coins.length < 1" msg="You do not have any coins yet" />
</template>

<script lang="ts" setup>
import Empty from "@/components/Empty.vue";
import { onMounted, reactive } from "vue";
import { Safe } from "@/lib/entity";
import { Coin } from "@/lib/types";
import { utils } from "@/utils";

interface State {
  coins: Coin[];
}

const state: State = reactive({ coins: [] });
const props = defineProps<{ safe: Safe }>();
defineEmits(["deposit"]);

onMounted(async () => {
  state.coins = await props.safe.getCoinBalances();
});
</script>

<style>
tr,
td {
  border: none !important;
  white-space: nowrap;
}
</style>
