<template>
  <v-row class="mt-10">
    <v-col md="6" sm="8" cols="12" class="mx-auto">
      <template v-if="wallets.length > 1">
        <div class="my-5">
          <h6 class="font-weight-bold text-h6 fonted">Connect your wallet</h6>
          <p>
            Choose any of your installed wallets to sign in to
            <strong>{{ config.appName }}</strong>
          </p>
        </div>

        <v-list class="py-0">
          <template v-for="(wallet, i) in wallets" :key="i">
            <v-divider v-if="i != 0" />

            <v-list-item class="pa-4" @click="connect(wallet.name)">
              <template v-slot:append>
                <v-avatar size="30">
                  <v-img :src="wallet.icon" :alt="wallet.name" />
                </v-avatar>
              </template>

              <template v-slot:prepend>
                <v-list-item-title>{{ wallet.name }}</v-list-item-title>
              </template>
            </v-list-item>
          </template>
        </v-list>
      </template>

      <template v-else>
        <div class="my-5">
          <h6 class="font-weight-bold text-h6 fonted">Connect your wallet</h6>
          <p>
            You do not have any Sui wallet installed. Select a wallet to install
            below
          </p>
        </div>

        <v-list class="py-0">
          <template v-for="(wallet, i) in suggestions" :key="i">
            <v-divider v-if="i != 0" />

            <v-list-item class="pa-4" :href="wallet.url" target="_blank">
              <template v-slot:append>
                <v-avatar size="30">
                  <v-img :src="wallet.icon" :alt="wallet.name" />
                </v-avatar>
              </template>

              <template v-slot:prepend>
                <v-list-item-title>{{ wallet.name }}</v-list-item-title>
              </template>
            </v-list-item>
          </template>
        </v-list>
      </template>
    </v-col>
  </v-row>
</template>

<script lang="ts" setup>
import { connection } from "@/utils";
import { useConnectionStore } from "@/store";
import { useRouter } from "vue-router";
import { config } from "@/config";
import { useToast } from "vue-toastification";

const router = useRouter();
const toast = useToast();
const connectionStore = useConnectionStore();
const { wallets } = connection;

async function connect(name: string) {
  try {
    await connectionStore.establishConnection(name);
    router.push({ name: "Safes" });
  } catch (e) {
    toast.error(e.message);
  }
}

const suggestions = [
  {
    name: "Sui Wallet",
    icon: "/assets/suiwallet.svg",
    url: "https://chrome.google.com/webstore/detail/sui-wallet/opcgpfmipidbgpenhmajoajpbobppdil",
  },
];
</script>
