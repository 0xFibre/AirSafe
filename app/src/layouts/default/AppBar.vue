<template>
  <Drawer
    :app-name="config.appName"
    :active-safe-id="activeSafeId!"
    :show="drawer"
    @showQr="toggleQrCode"
  />
  <AppBar
    :address="address"
    :is-connected="isConnected"
    :app-name="config.appName"
    @toggle-drawer="drawer = !drawer"
  />

  <SafeQRCode :id="activeSafeId!" :show="state.showQr" @toggle="toggleQrCode" />
</template>

<script lang="ts" setup>
import { useConnectionStore, useSafeStore } from "@/store";
import { storeToRefs } from "pinia";
import { reactive, Ref, ref } from "vue";
import { config } from "@/config";
import Drawer from "@/components/bars/Drawer.vue";
import AppBar from "@/components/bars/AppBar.vue";
import SafeQRCode from "@/components/SafeQRCode.vue";

const drawer: Ref<boolean | null> = ref(null);

const connectionStore = useConnectionStore();
const safeStore = useSafeStore();
const { address, isConnected } = storeToRefs(connectionStore);
const { activeSafeId } = storeToRefs(safeStore);

const state: { showQr: boolean } = reactive({ showQr: false });

function toggleQrCode() {
  state.showQr = !state.showQr;
}
</script>
