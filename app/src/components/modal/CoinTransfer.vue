<template>
  <v-dialog :model-value="show" persistent max-width="550px">
    <v-card>
      <v-card-text class="d-flex">
        <h6 class="text-h6 font-weight-bold fonted">
          Transfer {{ coin?.metadata.symbol }}
        </h6>

        <v-spacer />

        <v-btn
          flat
          density="compact"
          icon="mdi-close"
          @click="
            () => {
              $emit('toggle');
              input.amount = '';
              input.recipient = '';
            }
          "
        />
      </v-card-text>

      <v-divider />

      <v-card-text class="mb-3">
        <div class="mb-3">
          <p class="text-body-2 mb-3 fonted">Amount</p>
          <v-text-field
            type="number"
            color="primary"
            density="comfortable"
            variant="outlined"
            placeholder="Enter transfer amount"
            v-model="input.amount"
            hide-details
          />
        </div>

        <div class="mb-3">
          <p class="text-body-2 mb-3 fonted">Recipient</p>
          <v-text-field
            type="text"
            color="primary"
            density="comfortable"
            variant="outlined"
            placeholder="Enter recipient address"
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
          @click="$emit('transfer', input, coin)"
        >
          Transfer
        </v-btn>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script lang="ts" setup>
import { BasicCoin } from "@/lib/types";
import { reactive } from "vue";

defineProps<{ show: boolean; coin?: BasicCoin }>();
defineEmits(["transfer", "toggle"]);
const input: {
  amount: string;
  recipient: string;
} = reactive({ amount: "", recipient: "" });
</script>

<style>
.fonted {
  font-family: Circular, sans-serif !important;
}
</style>
