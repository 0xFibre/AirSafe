<template>
  <v-table hover fixed-header>
    <thead>
      <tr>
        <th>Coin</th>
        <th>Balance</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="coin in state.coins" :key="coin.id">
        <td>
          <div class="d-flex align-center">
            <v-avatar size="20" class="me-2">
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

            <div>{{ coin.metadata.name }}</div>
          </div>
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
            @click="$emit('transfer', coin)"
          >
            Transfer
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
defineEmits(["deposit", "transfer"]);

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
