<template>
  <v-app>
    <default-bar />
    <default-view />
  </v-app>
</template>

<script lang="ts" setup>
import DefaultBar from "@/layouts/default/AppBar.vue";
import DefaultView from "@/layouts/default/View.vue";
import { onMounted } from "vue";
import { useConnectionStore, useSafeStore } from "./store";
import { connection } from "./utils";

const { isConnected, wallet } = useConnectionStore();
const safeStore = useSafeStore();

onMounted(async () => {
  if (isConnected) {
    await connection.connect(wallet);
  }

  if (safeStore.activeSafeId) {
    safeStore.fetchActiveSafe();
  }
});
</script>
