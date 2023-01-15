<template>
  <v-dialog :model-value="show" persistent max-width="550px">
    <v-card>
      <v-card-text class="d-flex">
        <h6 class="text-h6 font-weight-bold fonted">Deposit Coin</h6>

        <v-spacer />

        <v-btn
          flat
          density="comfortable"
          icon="mdi-close"
          @click="
            () => {
              $emit('toggle');
              input.amount = '';
              input.coin = undefined;
            }
          "
        />
      </v-card-text>

      <v-divider />

      <v-card-text>
        <div class="mb-3">
          <p class="text-body-2 mb-3 fonted">Amount</p>

          <v-text-field
            type="number"
            color="primary"
            density="comfortable"
            variant="outlined"
            placeholder="Enter deposit amount"
            v-model="input.amount"
            hide-details
          />
        </div>

        <div class="mb-3">
          <p class="text-body-2 mb-3 fonted">Coin</p>

          <v-combobox
            :items="coins"
            item-title="metadata.name"
            item-value="coinType"
            color="primary"
            density="comfortable"
            variant="outlined"
            placeholder="Select or paste coin type"
            v-model="input.coin"
            @update:model-value="loadCoinMetadata"
            hide-details
          >
            <template v-slot:prepend-inner>
              <v-avatar size="25">
                <v-img :src="(<BasicCoin>input.coin)?.metadata?.iconUrl" />
              </v-avatar>
            </template>
          </v-combobox>
        </div>

        <v-btn
          class="mt-5"
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
import { coin } from "@/lib/coin";
import { BasicCoin, Coin } from "@/lib/types";
import { watch, reactive } from "vue";

const props = defineProps<{ show: boolean; coin?: BasicCoin; coins: Coin[] }>();
defineEmits(["deposit", "toggle"]);

interface Input {
  coin?: BasicCoin | string;
  amount: string;
}

const input: Input = reactive({ amount: "" });

watch(props, () => {
  input.coin = props.coin;
});

async function loadCoinMetadata() {
  if (typeof input.coin === "string") {
    const metadata = await coin.getCoinMetadata(input.coin);
    input.coin = { coinType: input.coin, metadata };
  }
}
</script>

<style>
.fonted {
  font-family: Circular, sans-serif !important;
}
</style>
