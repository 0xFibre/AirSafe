<template>
  <v-dialog :model-value="show" persistent max-width="550px">
    <v-card>
      <v-card-text>
        <h6 class="text-h6 font-weight-bold fonted">Deposit Coin</h6>
      </v-card-text>

      <v-divider />

      <v-card-text class="mb-3">
        <div class="mb-2">
          <p class="text-body-2 mb-3 fonted">Deposit Amount</p>
          <v-text-field
            color="primary"
            density="comfortable"
            variant="outlined"
            placeholder="Enter deposit amount"
            v-model="input.amount"
          />
        </div>

        <v-btn
          flat
          block
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
import { reactive } from "vue";

interface Input {
  amount: string;
  coinType: string;
}

let input: Input = reactive({ amount: "", coinType: "" });
defineProps<{ show: boolean }>();
defineEmits(["deposit"]);
</script>

<style>
.fonted {
  font-family: Circular, sans-serif !important;
}
</style>
