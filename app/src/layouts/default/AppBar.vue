<template>
  <v-navigation-drawer v-model="drawer" v-if="!$route.meta.hideSideBar">
    <template v-slot:prepend>
      <v-list-item lines="two">
        <template v-slot:prepend>
          <v-avatar rounded v-if="activeSafeId">
            <v-img :src="blockie(activeSafeId)" />
          </v-avatar>
        </template>

        <v-list-item-title v-if="activeSafeId">
          {{ utils.truncate0x(activeSafeId) }}
          <v-btn flat variant="text" icon="mdi-content-copy" size="x-small" />
        </v-list-item-title>

        <v-list-item-subtitle style="opacity: unset">
          <v-btn flat variant="text" icon="mdi-qrcode" size="x-small" />
          <v-btn flat variant="text" icon="mdi-open-in-new" size="x-small" />
        </v-list-item-subtitle>
      </v-list-item>
    </template>

    <v-divider />

    <v-list density="comfortable" nav>
      <template v-for="(item, i) in sideBarItems" :key="i">
        <v-divider class="my-3" v-if="item.divider" />
        <v-list-item
          v-else
          rounded="shaped"
          :to="item.path"
          color="primary"
          density="comfortable"
        >
          <template v-slot:prepend>
            <v-avatar>
              <v-icon :icon="item.icon" />
            </v-avatar>
          </template>
          <v-list-item-title>{{ item.title }}</v-list-item-title>
        </v-list-item>
      </template>
    </v-list>
  </v-navigation-drawer>

  <v-app-bar flat density="comfortable" v-if="!$route.meta.hideAppBar">
    <v-app-bar-nav-icon
      @click="drawer = !drawer"
      class="d-md-block d-lg-none"
    />

    <v-app-bar-title>
      <h4>Vallet Safe</h4>
    </v-app-bar-title>

    <v-spacer />

    <div v-if="isConnected">
      <v-btn flat variant="text" prepend-icon="mdi-view-sequential" to="/safes">
        Safes
      </v-btn>

      <v-btn
        id="menu-activator"
        flat
        variant="text"
        prepend-icon="mdi-account-outline"
        class="me-3"
      >
        {{ utils.truncate0x(address) }}
      </v-btn>

      <v-menu activator="#menu-activator" location="bottom">
        <v-list nav density="comfortable">
          <v-list-item
            v-for="(item, index) in menuItems"
            :key="index"
            :value="index"
          >
            <template v-slot:prepend>
              <v-icon :icon="item.icon" />
            </template>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </div>

    <v-btn v-else flat rounded variant="flat" color="primary" to="/connect">
      Connect wallet
    </v-btn>
  </v-app-bar>
</template>

<script lang="ts" setup>
import { utils } from "@/utils";
import blockie from "ethereum-blockies-base64";
import { useConnectionStore, useSafeStore } from "@/store";
import { storeToRefs } from "pinia";
import { Ref, ref } from "vue";

const drawer: Ref<boolean | null> = ref(null);
const connectionStore = useConnectionStore();
const safeStore = useSafeStore();
const { address, isConnected } = storeToRefs(connectionStore);
const { activeSafeId } = storeToRefs(safeStore);

const sideBarItems = [
  {
    title: "Dashboard",
    icon: "mdi-view-dashboard",
    path: "/dashboard",
  },
  {
    title: "Transactions",
    icon: "mdi-arrow-top-left-bottom-right",
    path: "/transactions",
  },
  {
    title: "Assets",
    icon: "mdi-atom",
    path: "/assets",
  },
  {
    title: "Owners",
    icon: "mdi-account-multiple",
    path: "/owners",
  },
  {
    divider: true,
  },
  {
    title: "Settings",
    icon: "mdi-cog",
    path: "/settings",
  },
];

const menuItems = [
  {
    title: "Settings",
    icon: "mdi-cog",
  },
];
</script>
