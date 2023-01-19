<template>
  <v-dialog :model-value="show" persistent max-width="550px">
    <v-card>
      <v-card-text class="d-flex">
        <h6 class="text-h6 font-weight-bold">Deposit NFT</h6>

        <v-spacer />

        <v-btn
          flat
          density="comfortable"
          icon="mdi-close"
          @click="toggleModal"
        />
      </v-card-text>

      <v-divider />
      <v-card-text class="mb-3">
        <p class="text-body-2 font-weight-bold mb-3">Select an NFT</p>

        <v-row>
          <template v-for="(nft, i) of nfts" :key="i">
            <v-col cols="6">
              <v-card
                border
                flat
                :variant="input.nft?.id == nft.id ? 'outlined' : undefined"
                :color="input.nft?.id == nft.id ? 'primary' : undefined"
              >
                <v-card-text>
                  <v-img
                    style="border-radius: 4px"
                    :src="nft.url"
                    height="160px"
                    cover
                  />

                  <p class="text-body-2 my-3">{{ nft.name || "N/A" }}</p>

                  <v-btn
                    block
                    flat
                    variant="tonal"
                    density="comfortable"
                    @click="selectNft(nft)"
                  >
                    Select
                  </v-btn>
                </v-card-text>
              </v-card>
            </v-col>
          </template>
        </v-row>

        <v-btn
          flat
          block
          class="mt-5"
          variant="flat"
          color="primary"
          @click="$emit('deposit', input)"
        >
          Deposit
        </v-btn>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script lang="ts" setup>
import { Nft } from "@/lib/types";
import { reactive } from "vue";

const event = defineEmits(["deposit", "toggle"]);
defineProps<{ show: boolean; nfts: Nft[] }>();
const input: { nft?: Nft } = reactive({ nft: undefined });

function toggleModal() {
  event("toggle", "deposit");
  input.nft = undefined;
}

function selectNft(nft: Nft) {
  if (input.nft?.id === nft.id) {
    input.nft = undefined;
  } else {
    input.nft = nft;
  }
}
</script>
