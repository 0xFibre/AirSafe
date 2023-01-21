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
      <tr v-for="coin in coins" :key="coin.id">
        <td>
          <div class="d-flex align-center">
            <v-avatar size="20" class="me-2">
              <v-img :src="coin.metadata.iconUrl" />
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
            @click="$emit('send', coin)"
          >
            Send
          </v-btn>
        </td>
      </tr>
    </tbody>
  </v-table>

  <Empty v-if="coins.length < 1" msg="This safe does not have any coin" />
</template>

<script lang="ts" setup>
import Empty from "@/components/Empty.vue";
import { Coin } from "@/lib/types";
import { utils } from "@/utils";

defineProps<{ coins: Coin[] }>();
defineEmits(["deposit", "send"]);
</script>

<style scoped>
tr,
td {
  border: none !important;
  white-space: nowrap;
}
</style>
