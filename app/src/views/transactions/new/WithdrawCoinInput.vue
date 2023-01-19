<template>
  <div class="mb-3">
    <p class="text-body-2 mb-3">Amount</p>
    <v-text-field
      type="number"
      color="primary"
      density="compact"
      variant="outlined"
      placeholder="10000"
      v-model="input.amount"
      @input="() => $emit('change', 'amount', input.amount)"
      hide-details
    />
  </div>

  <div class="mb-3">
    <p class="text-body-2 mb-3">Coin</p>

    <v-select
      :items="coins"
      item-title="metadata.name"
      color="primary"
      density="compact"
      variant="outlined"
      placeholder="Select coin"
      v-model="input.coin"
      @update:model-value="() => $emit('change', 'coin', input.coin)"
      hide-details
      return-object
    >
      <template v-slot:prepend-inner>
        <v-avatar size="25">
          <v-img :src="(<BasicCoin>input.coin)?.metadata?.iconUrl" />
        </v-avatar>
      </template>
    </v-select>
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
import { BasicCoin } from "@/lib/types";
import { reactive } from "vue";

defineEmits(["change"]);
defineProps<{ coins: BasicCoin[] }>();

interface Input {
  amount: string;
  recipient: string;
  coin?: BasicCoin;
}

const input: Input = reactive({ amount: "", recipient: "" });
</script>
