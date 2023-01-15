<template>
  <v-row>
    <v-col cols="12" md="8" class="mx-auto">
      <div class="d-flex mb-3">
        <h6 class="text-h6 fonted font-weight-bold">Owners</h6>
        <v-spacer />
        <v-btn flat variant="text" density="comfortable">Add new owner</v-btn>
      </div>

      <v-list lines="two">
        <v-list-item
          class="my-0 py-2"
          v-for="owner in safe?.owners || []"
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
            <v-btn flat variant="text" icon="mdi-delete-outline" size="small" />
          </template>
        </v-list-item>
      </v-list>
    </v-col>
  </v-row>
</template>

<style>
.fonted {
  font-family: Circular, sans-serif !important;
}
</style>

<script lang="ts" setup>
import { useSafeStore } from "@/store";
import makeBlockie from "ethereum-blockies-base64";
import { storeToRefs } from "pinia";
import { onMounted } from "vue";
import { env } from "@/config";

const safeStore = useSafeStore();
const { safe } = storeToRefs(safeStore);

onMounted(async () => {
  await safeStore.fetchActiveSafe();
});
</script>
