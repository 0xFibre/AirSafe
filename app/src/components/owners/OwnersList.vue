<template>
  <v-list lines="two">
    <v-list-item
      class="my-0 py-2"
      v-for="owner in owners"
      :prepend-avatar="makeBlockie(owner)"
      :key="owner"
    >
      <v-list-item-title>{{ owner }}</v-list-item-title>

      <v-list-item-action>
        <v-btn flat variant="text" icon="mdi-qrcode" size="x-small" />
        <v-btn flat variant="text" icon="mdi-content-copy" size="x-small" />
        <v-btn
          flat
          target="_blank"
          :href="`${env.suiExplorerUrl}/address/${owner}?network=${env.suiNetwork}`"
          variant="text"
          icon="mdi-open-in-new"
          size="x-small"
        />
      </v-list-item-action>

      <template v-slot:append>
        <v-btn
          flat
          variant="text"
          icon="mdi-delete-outline"
          size="small"
          @click="$emit('remove', owner)"
        />
      </template>
    </v-list-item>
  </v-list>
</template>

<script lang="ts" setup>
import { env } from "@/config";
import makeBlockie from "ethereum-blockies-base64";

defineEmits(["remove"]);
withDefaults(defineProps<{ owners?: string[] }>(), { owners: () => [] });
</script>
