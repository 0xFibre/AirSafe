<template>
  <v-navigation-drawer
    elevation="0"
    border="0"
    v-model="drawer"
    v-if="!$route.meta.hideSideBar"
  >
    <div class="text-center my-3">
      <h6 class="text-h6 fonted font-weight-bold">Vallet Safe</h6>
    </div>

    <v-divider class="mb-3 mt-5" />

    <v-list-item lines="two">
      <template v-slot:prepend>
        <v-avatar rounded size="50" v-if="activeSafeId">
          <v-img :src="blockie(activeSafeId)" />
        </v-avatar>
      </template>

      <v-list-item-title v-if="activeSafeId">
        {{ utils.truncate0x(activeSafeId) }}
      </v-list-item-title>

      <v-list-item-subtitle style="opacity: unset">
        <v-btn flat variant="text" icon="mdi-qrcode" size="x-small" />
        <v-btn flat variant="text" icon="mdi-content-copy" size="x-small" />
        <v-btn flat variant="text" icon="mdi-open-in-new" size="x-small" />
      </v-list-item-subtitle>
    </v-list-item>

    <div class="pa-3">
      <v-btn flat block variant="flat" color="primary" prepend-icon="mdi-plus">
        New transaction
      </v-btn>
    </div>

    <v-list density="comfortable" nav>
      <template v-for="(item, i) in sideBarItems">
        <template v-if="item.children">
          <v-list-group :value="item.title" :key="i">
            <template v-slot:activator="{ props }">
              <v-list-item
                color="primary"
                v-bind="props"
                :prepend-icon="item.icon"
                :title="item.title"
              />
            </template>

            <template v-for="(child, i) in item.children" :key="i">
              <v-list-item
                color="primary"
                :title="child.title"
                :prepend-icon="child.icon"
                :value="child.title"
                :to="child.path"
              />
            </template>
          </v-list-group>
        </template>

        <template v-else>
          <v-list-item
            :key="i"
            color="primary"
            :to="item.path"
            density="comfortable"
            :title="item.title"
            :prepend-icon="item.icon"
          />
        </template>
      </template>
    </v-list>
  </v-navigation-drawer>

  <v-app-bar flat v-if="!$route.meta.hideAppBar">
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
    icon: "mdi-view-dashboard-outline",
    path: "/dashboard",
  },
  {
    title: "Assets",
    icon: "mdi-atom",
    children: [
      {
        title: "Coins",
        icon: "mdi-checkbox-multiple-blank-circle-outline",
        path: "/assets/coins",
      },
      {
        title: "NFTs",
        icon: "mdi-layers-outline",
        path: "/assets/nfts",
      },
    ],
  },
  {
    title: "Transactions",
    icon: "mdi-arrow-top-left-bottom-right",
    path: "/transactions",
  },
  {
    title: "Owners",
    icon: "mdi-account-multiple-outline",
    path: "/owners",
  },
  // {
  //   divider: true,
  // },
  {
    title: "Settings",
    icon: "mdi-cog-outline",
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
