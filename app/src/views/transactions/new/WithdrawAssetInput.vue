<template>
  <div class="mb-3">
    <p class="text-body-2 mb-3">Select an NFT</p>

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

              <p class="text-body-2 my-3">{{ nft.name }}</p>

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
  </div>

  <div class="mb-3">
    <p class="text-body-2 mb-3">Recipient address</p>
    <v-text-field
      type="text"
      color="primary"
      density="compact"
      variant="outlined"
      placeholder="0x..."
      v-model="input.recipient"
      @input="() => $emit('change', 'recipient', input.recipient)"
      hide-details
    />
  </div>
</template>

<script lang="ts" setup>
import { Nft } from "@/lib/types";
import { reactive } from "vue";

const emits = defineEmits(["change"]);
defineProps<{ nfts: Nft[] }>();

const input: { recipient: string; nft?: Nft } = reactive({ recipient: "" });

function selectNft(nft: Nft) {
  if (input.nft?.id === nft.id) {
    input.nft = undefined;
  } else {
    input.nft = nft;
  }

  emits("change", "nft", input.nft);
}
</script>
