<template>
  <v-card flat class="mb-3">
    <v-card-text>
      <h6 class="text-body-1 font-weight-bold">
        {{ transaction.typeValue }}
      </h6>
    </v-card-text>

    <v-divider />

    <v-card-text>
      <template v-if="transaction.type == 0">
        <KVText
          title="Amount"
          :value="`${utils.formatBalance(transaction.input.amount, transaction.coin?.metadata.decimals!)} ${transaction?.coin?.metadata.symbol}`"
        />

        <KVText
          title="Recipient"
          :value="utils.truncate0x(`0x${transaction.input.recipient}`)"
        />
      </template>
      <template v-if="transaction.type == 1">
        <KVText title="NFT ID" :value="transaction.input.assetId" />

        <KVText
          title="Recipient"
          :value="utils.truncate0x(`0x${transaction.input.recipient}`)"
        />
      </template>
      <template v-else>
        <KVText
          title="Owner"
          v-if="transaction.type == 2 || transaction.type == 3"
          :value="utils.truncate0x(transaction.input.owner)"
        />

        <KVText
          v-if="
            transaction.type == 2 ||
            transaction.type == 3 ||
            transaction.type == 4
          "
          title="Threshold"
          :value="transaction.input.threshold"
        />
      </template>
    </v-card-text>
  </v-card>
</template>

<script lang="ts" setup>
import KVText from "@/components/text/KVText.vue";
import { SafeTransaction } from "@/lib/entity";
import { utils } from "@/utils";

defineProps<{ transaction: SafeTransaction }>();
</script>
