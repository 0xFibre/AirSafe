<template>
  <v-dialog :model-value="show" persistent max-width="550px">
    <v-card>
      <v-card-text class="d-flex">
        <h6 class="text-h6 font-weight-bold fonted">
          Deposit {{ coin?.metadata.symbol }}
        </h6>

        <v-spacer />

        <v-btn
          flat
          density="compact"
          icon="mdi-close"
          @click="
            () => {
              $emit('toggle');
              amount = '';
            }
          "
        />
      </v-card-text>

      <v-divider />

      <v-card-text class="mb-3">
        <div class="mb-2">
          <p class="text-body-2 mb-3 fonted">Deposit Amount</p>
          <v-text-field
            type="number"
            color="primary"
            density="comfortable"
            variant="outlined"
            placeholder="Enter deposit amount"
            v-model="amount"
          />
        </div>

        <v-btn
          flat
          block
          variant="flat"
          color="primary"
          @click="$emit('deposit', amount, coin)"
        >
          Deposit
        </v-btn>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script lang="ts" setup>
import { Coin } from "@/lib/types";
import { ref, Ref } from "vue";

const amount: Ref<string> = ref("");

defineProps<{ show: boolean; coin?: Coin }>();
defineEmits(["deposit", "toggle"]);
</script>

<style>
.fonted {
  font-family: Circular, sans-serif !important;
}
</style>
