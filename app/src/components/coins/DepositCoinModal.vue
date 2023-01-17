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
          @click="toggleModal"
        />
      </v-card-text>

      <v-divider />

      <v-card-text class="mb-3">
        <div class="mb-3">
          <p class="text-body-2 mb-3 fonted">Amount to deposit</p>

          <v-text-field
            type="number"
            color="primary"
            density="comfortable"
            variant="outlined"
            placeholder="1000"
            v-model="input.amount"
            hide-details
          />
        </div>

        <div class="mb-3">
          <p class="text-body-2 mb-3 fonted">Coin to deposit</p>

          <v-combobox
            :items="coins"
            item-title="metadata.name"
            color="primary"
            density="comfortable"
            variant="outlined"
            placeholder="Select or paste coin type"
            v-model="input.coin"
            @update:model-value="loadCoinMetadata"
            hide-details
            return-object
          >
            <template v-slot:prepend-inner>
              <v-avatar size="25">
                <v-img :src="(<BasicCoin>input.coin)?.metadata?.iconUrl" />
              </v-avatar>
            </template>
          </v-combobox>
        </div>

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
import { coin } from "@/lib/coin";
import { BasicCoin } from "@/lib/types";
import { watch, reactive } from "vue";

const event = defineEmits(["deposit", "toggle"]);
const props = defineProps<{
  show: boolean;
  coin?: BasicCoin;
  coins: BasicCoin[];
}>();
const input: {
  coin?: BasicCoin | string;
  amount: string;
} = reactive({ amount: "" });

watch(
  () => props.coin,
  (coin) => (input.coin = coin)
);

async function loadCoinMetadata() {
  if (typeof input.coin === "string") {
    const metadata = await coin.getCoinMetadata(input.coin);
    input.coin = { coinType: input.coin, metadata };
  }
}

function toggleModal() {
  event("toggle", "deposit");

  input.amount = "";
  input.coin = undefined;
}
</script>
