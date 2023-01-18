<template>
  <v-row class="mt-10">
    <v-col md="6" sm="8" cols="12" class="mx-auto">
      <h6 class="my-3 font-weight-bold text-h6 fonted">Connect your wallet</h6>

      <v-list>
        <template v-for="(wallet, i) in wallets" :key="i">
          <v-divider v-if="i != 0" />

          <v-list-item @click="connect(wallet.name)">
            <template v-slot:prepend>
              <v-avatar size="30">
                <v-img :src="wallet.icon" :alt="wallet.name" />
              </v-avatar>
            </template>

            <v-list-item-title>{{ wallet.name }}</v-list-item-title>
          </v-list-item>
        </template>
      </v-list>
    </v-col>
  </v-row>
</template>

<script lang="ts" setup>
import { connection } from "@/utils";
import { useConnectionStore } from "@/store";
import { useRouter } from "vue-router";

const router = useRouter();
const connectionStore = useConnectionStore();
const { wallets } = connection;

async function connect(name: string) {
  await connectionStore.establishConnection(name);
  router.push({ name: "Safes" });
}
</script>
