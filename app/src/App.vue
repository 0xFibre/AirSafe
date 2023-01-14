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
import { useConnectionStore } from "./store";
import { connection } from "./utils";

const { isConnected, wallet } = useConnectionStore();

onMounted(async () => {
  if (isConnected) {
    await connection.connect(wallet);
  }
});
</script>
