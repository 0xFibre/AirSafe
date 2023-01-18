<template>
  <v-app-bar flat v-if="!$route.meta.hideAppBar">
    <v-app-bar-nav-icon
      @click="$emit('toggleDrawer')"
      class="d-md-block d-lg-none"
    />

    <v-app-bar-title class="d-lg-none">
      <h4 class="no-select">{{ appName }}</h4>
    </v-app-bar-title>

    <v-spacer class="d-lg-none" />

    <v-btn
      v-if="isConnected"
      flat
      variant="text"
      prepend-icon="mdi-safe"
      to="/safes"
    >
      Safes
    </v-btn>

    <v-spacer class="d-none d-lg-block" />

    <div v-if="isConnected">
      <v-btn
        id="menu-activator"
        flat
        variant="text"
        prepend-icon="mdi-account-outline"
        class="me-3"
      >
        <span class="d-none d-sm-block"> {{ utils.truncate0x(address) }}</span>
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
