<template>
  <v-dialog :model-value="show" persistent max-width="550px">
    <v-card>
      <v-card-text class="d-flex">
        <h6 class="text-h6 font-weight-bold">Send NFT</h6>

        <v-spacer />

        <v-btn
          flat
          density="compact"
          icon="mdi-close"
          @click="
            () => {
              $emit('toggle', 'send');
              input.recipient = '';
            }
          "
        />
      </v-card-text>

      <v-card-text class="mb-5">
        <v-row class="mb-5">
          <v-col cols="12" sm="6">
            <v-img style="border-radius: 4px" :src="nft?.url" cover />
          </v-col>
          <v-col cols="12" sm="6">
            <h6 class="text-h6 font-weight-bold">{{ nft?.name }}</h6>
            <p class="text-body-2">{{ nft?.description }}</p>
          </v-col>
        </v-row>

        <div class="mb-3">
          <p class="text-body-2 mb-3">Recipient address</p>
          <v-text-field
            type="text"
            color="primary"
            density="compact"
            variant="outlined"
            placeholder="0x..."
            v-model="input.recipient"
            hide-details
          />
        </div>

        <v-btn
          flat
          block
          class="mt-5"
          variant="flat"
          color="primary"
          @click="$emit('send', { ...input, nft })"
          :disabled="submitting"
        >
          Send
        </v-btn>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script lang="ts" setup>
import { Nft } from "@/lib/types";
import { reactive } from "vue";

defineEmits(["send", "toggle"]);
defineProps<{ show: boolean; submitting: boolean; nft?: Nft }>();

const input: { recipient: string } = reactive({ recipient: "" });
</script>
