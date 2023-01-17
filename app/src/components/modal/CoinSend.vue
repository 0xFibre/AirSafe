<template>
  <v-dialog :model-value="show" persistent max-width="550px">
    <v-card>
      <v-card-text class="d-flex">
        <h6 class="text-h6 font-weight-bold fonted">
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
          <p class="text-body-2 mb-3 fonted">Amount</p>
          <v-text-field
            type="number"
            color="primary"
            density="comfortable"
            variant="outlined"
            placeholder="Enter amount to semd"
            v-model="input.amount"
            hide-details
          />
        </div>

        <div class="mb-3">
          <p class="text-body-2 mb-3 fonted">Coin</p>

          <v-select
            :items="coins"
            item-title="metadata.name"
            item-value="coinType"
            color="primary"
            density="comfortable"
            variant="outlined"
            placeholder="Select coin"
            v-model="input.coin"
            hide-details
          >
            <template v-slot:prepend-inner>
              <v-avatar size="25">
                <v-img :src="(<BasicCoin>input.coin)?.metadata?.iconUrl" />
              </v-avatar>
            </template>
          </v-select>
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

watch(props, () => (input.coin = props.coin));
</script>
