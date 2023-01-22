<template>
  <v-card border flat class="mb-3">
    <v-card-text>
      <h6 class="text-body-1 font-weight-bold">Info</h6>
    </v-card-text>

    <v-divider />

    <v-card-text>
      <KVText title="Creator" :value="utils.truncate0x(transaction.creator)" />
      <KVText title="Type" :value="transaction.typeValue" />
      <KVText title="Status" :value="transaction.statusValue" />
    </v-card-text>
  </v-card>
</template>
<script lang="ts" setup>
import KVText from "@/components/text/KVText.vue";
import { SafeTransaction } from "@/lib/entity";
import { utils } from "@/utils";

defineProps<{ transaction: SafeTransaction }>();
</script>
