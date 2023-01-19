<template>
  <v-navigation-drawer
    elevation="0"
    border="0"
    v-bind:model-value="show"
    v-if="!$route.meta.hideSideBar"
  >
    <div class="text-center my-3">
      <h6 class="text-h6 fonted font-weight-bold no-select">
        {{ appName }}
      </h6>
    </div>

    <v-divider class="mb-3 mt-5" />

    <v-list-item lines="two">
      <template v-slot:prepend>
        <v-avatar rounded size="50" v-if="activeSafeId">
          <v-img :src="makeBlockie(activeSafeId)" />
        </v-avatar>
      </template>

      <v-list-item-title v-if="activeSafeId">
        {{ utils.truncate0x(activeSafeId) }}
      </v-list-item-title>

      <v-list-item-subtitle style="opacity: unset">
        <v-btn
          flat
          variant="text"
          icon="mdi-qrcode"
          size="x-small"
          @click="$emit('showQr')"
        />
        <v-btn flat variant="text" icon="mdi-content-copy" size="x-small" />
        <v-btn flat variant="text" icon="mdi-open-in-new" size="x-small" />
      </v-list-item-subtitle>
    </v-list-item>

    <div class="pa-3">
      <v-btn
        flat
        block
        variant="flat"
        color="primary"
        prepend-icon="mdi-plus"
        to="/transaction/new"
      >
        New transaction
      </v-btn>
    </div>

    <v-list nav>
      <template v-for="(item, i) in iitems">
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
</template>

<script lang="ts" setup>
import { utils } from "@/utils";
import makeBlockie from "ethereum-blockies-base64";

defineProps<{ show: boolean | null; activeSafeId: string; appName: string }>();
defineEmits(["showQr"]);

const iitems = [
  {
    title: "Dashboard",
    icon: "mdi-view-dashboard-outline",
    path: "/",
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
  {
    title: "Settings",
    icon: "mdi-cog-outline",
    path: "/settings",
  },
];
</script>
