<template>
  <v-app-bar flat v-if="!$route.meta.hideAppBar">
    <v-app-bar-nav-icon
      @click="$emit('toggleDrawer')"
      class="d-md-block d-lg-none"
    />

    <v-app-bar-title class="d-lg-none">
      <h4 class="no-select">{{ appName }}</h4>
    </v-app-bar-title>

    <v-spacer />

    <div class="d-none d-sm-inline" v-if="isConnected">
      <v-btn
        flat
        class="me-3 safe-nav-btn"
        variant="text"
        prepend-icon="mdi-safe"
        density="compact"
        to="/safes"
      >
        Safes
      </v-btn>
    </div>

    <div v-if="isConnected">
      <v-btn
        id="menu-activator"
        flat
        density="comfortable"
        prepend-icon="mdi-account-outline"
        class="me-3"
      >
        <span> {{ utils.truncate0x(address) }}</span>
      </v-btn>

      <AppBarMenu activator="#menu-activator" :items="menuItems" />
    </div>

    <v-btn v-else flat rounded variant="flat" color="primary" to="/connect">
      Connect wallet
    </v-btn>
  </v-app-bar>
</template>

<script lang="ts" setup>
import { useConnectionStore } from "@/store";
import { utils } from "@/utils";
import { useRouter } from "vue-router";
import AppBarMenu from "./AppBarMenu.vue";

defineEmits(["toggleDrawer"]);
defineProps<{
  isConnected: boolean;
  address: string;
  appName: string;
}>();

const menuItems = [
  {
    title: "View in explorer",
    icon: "mdi-open-in-new",
  },
  {
    title: "Disconnect",
    icon: "mdi-logout",
    function: disconnect,
  },
];

const connectionStore = useConnectionStore();
const router = useRouter();

async function disconnect() {
  await connectionStore.destroyConnection();
  router.push({ name: "Connect" });
}
</script>
