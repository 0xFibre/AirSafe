<template>
  <v-list lines="two">
    <v-list-item class="my-0 py-2" v-for="owner in owners" :key="owner">
      <v-list-item-title>{{ owner }}</v-list-item-title>

      <template v-slot:prepend>
        <v-avatar size="50">
          <v-img :src="makeBlockie(owner)" />
        </v-avatar>
      </template>

      <v-list-item-subtitle style="opacity: unset">
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
      </v-list-item-subtitle>

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
