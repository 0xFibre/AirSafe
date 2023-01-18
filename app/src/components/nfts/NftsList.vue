<template>
  <Empty v-if="nfts.length < 1" msg="No NFTs yet" />

  <v-row v-else>
    <template v-for="(nft, i) of nfts">
      <v-col sm="4" md="3" cols="6">
        <v-card flat>
          <v-card-text>
            <v-img
              style="border-radius: 4px"
              :src="nft.url"
              height="160px"
              cover
            />

            <p class="text-body-2 my-3">{{ nft.name }}</p>

            <v-btn
              block
              flat
              variant="tonal"
              density="comfortable"
              @click="$emit('send', nft)"
            >
              Send NFT
            </v-btn>
          </v-card-text>
        </v-card>
      </v-col>
    </template>
  </v-row>
</template>

<script lang="ts" setup>
import Empty from "@/components/Empty.vue";
import { Nft } from "@/lib/types";
import { utils } from "@/utils";

defineProps<{ nfts: Nft[] }>();
defineEmits(["send"]);
</script>

<style scoped>
tr,
td {
  border: none !important;
  white-space: nowrap;
}
</style>
