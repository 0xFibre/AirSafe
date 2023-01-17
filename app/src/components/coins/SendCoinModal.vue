<template>
  <v-dialog :model-value="show" persistent max-width="550px">
    <v-card>
      <v-card-text class="d-flex">
        <h6 class="text-h6 font-weight-bold">
          Send {{ coin?.metadata?.symbol }}
        </h6>

        <v-spacer />

        <v-btn
          flat
          density="compact"
          icon="mdi-close"
          @click="
            () => {
              $emit('toggle', 'send');
              input.amount = '';
              input.recipient = '';
            }
          "
        />
      </v-card-text>

      <v-divider />

      <v-card-text class="mb-3">
        <div class="mb-3">
          <p class="text-body-2 mb-3">Amount to send</p>
          <v-text-field
            type="number"
            color="primary"
            density="compact"
            variant="outlined"
            placeholder="10000"
            v-model="input.amount"
            hide-details
          />
        </div>

        <div class="mb-3">
          <p class="text-body-2 mb-3">Coin to send</p>

          <v-select
            :items="coins"
            item-title="metadata.name"
            color="primary"
            density="compact"
            variant="outlined"
            placeholder="Select coin"
            v-model="input.coin"
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
            hide-details
          />
        </div>

        <v-btn
          flat
          block
          class="mt-5"
          variant="flat"
          color="primary"
          @click="$emit('send', input)"
        >
          Send
        </v-btn>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script lang="ts" setup>
import { BasicCoin } from "@/lib/types";
import { reactive, watch } from "vue";

defineEmits(["send", "toggle"]);
const props = defineProps<{
  show: boolean;
  coin?: BasicCoin;
  coins: BasicCoin[];
}>();
const input: {
  amount: string;
  recipient: string;
  coin?: BasicCoin;
} = reactive({ amount: "", recipient: "", coin: undefined });

watch(
  () => props.coin,
  (coin) => (input.coin = coin)
);
</script>
