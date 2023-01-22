<template>
  <v-app-bar border flat v-if="!$route.meta.hideAppBar">
    <v-container class="fill-height d-flex align-center">
      <v-app-bar-nav-icon
        @click="$emit('toggleDrawer')"
        class="d-md-block d-lg-none"
      />

      <v-app-bar-title
        :class="$route.meta.access != 'auth' ? 'd-lg-none' : undefined"
      >
        <h4 class="no-select">{{ appName }}</h4>
      </v-app-bar-title>

      <v-spacer />

      <div v-if="isConnected">
        <v-btn id="menu-activator" flat prepend-icon="mdi-account-outline">
          <span> {{ utils.truncate0x(address, 3) }}</span>
        </v-btn>

        <AppBarMenu activator="#menu-activator" :items="menuItems" />
      </div>

      <v-btn v-else flat variant="tonal" color="primary" to="/connect">
        Connect wallet
      </v-btn>
    </v-container>
  </v-app-bar>
</template>

<script lang="ts" setup>
import { env } from "@/config";
import { useConnectionStore } from "@/store";
import { utils } from "@/utils";
import { storeToRefs } from "pinia";
import { useRouter } from "vue-router";
import AppBarMenu from "./AppBarMenu.vue";

defineEmits(["toggleDrawer"]);
defineProps<{
  isConnected: boolean;
  address: string;
  appName: string;
}>();

const connectionStore = useConnectionStore();
const { address } = storeToRefs(connectionStore);
const router = useRouter();

const menuItems = [
  {
    title: "My safes",
    icon: "mdi-folder-multiple-outline",
    function: () => router.push("/safes"),
  },
  {
    title: "View on explorer",
    icon: "mdi-open-in-new",
    function: () =>
      window.open(`${env.suiExplorerUrl}/address/${address.value}`),
  },
  {
    title: "Disconnect",
    icon: "mdi-logout",
    function: disconnect,
  },
];

async function disconnect() {
  await connectionStore.destroyConnection();
  router.push({ name: "Connect" });
}
</script>
