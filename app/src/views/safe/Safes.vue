<template>
  <v-row>
    <v-col cols="12" md="8" class="mx-auto">
      <div class="d-flex mb-3">
        <h6 class="text-h6 fonted font-weight-bold">Safes</h6>
        <v-spacer />
        <v-btn
          flat
          variant="text"
          density="comfortable"
          prepend-icon="mdi-plus"
          to="/safe/create"
        >
          Create safe
        </v-btn>
      </div>

      <v-list lines="two">
        <v-list-item
          class="my-0 py-2"
          :prepend-avatar="blockie(safe.id)"
          v-for="safe in safes"
          :key="safe.id"
        >
          <v-list-item-title>{{ safe.id }}</v-list-item-title>

          <v-list-item-action>
            <v-btn flat variant="text" icon="mdi-qrcode" size="x-small" />
            <v-btn flat variant="text" icon="mdi-content-copy" size="x-small" />
            <v-btn
              flat
              target="_blank"
              :href="`${env.suiExplorerUrl}/object/${safe.id}?network=${env.suiNetwork}`"
              variant="text"
              icon="mdi-open-in-new"
              size="x-small"
            />
          </v-list-item-action>

          <template v-slot:append>
            <v-btn
              flat
              variant="text"
              density="comfortable"
              append-icon="mdi-arrow-right"
              :to="`/${safe.id}/dashboard`"
            >
              open
            </v-btn>
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
import { env } from "@/config";
import { useSafeStore } from "@/store";
import { storeToRefs } from "pinia";
import { onMounted } from "vue";
import blockie from "ethereum-blockies-base64";

const safeStore = useSafeStore();
const { safes } = storeToRefs(safeStore);

onMounted(async () => {
  await safeStore.fetchSafes();
});
</script>
