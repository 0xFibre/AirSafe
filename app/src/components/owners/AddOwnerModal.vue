<template>
  <v-dialog :model-value="show" persistent max-width="550px">
    <v-card>
      <v-card-text class="d-flex">
        <h6 class="text-h6 font-weight-bold fonted">Add owner</h6>

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
          <p class="text-body-2 mb-3 fonted">Owner address</p>

          <v-text-field
            type="text"
            color="primary"
            density="compact"
            variant="outlined"
            placeholder="0x..."
            v-model="input.owner"
            hide-details
          />
        </div>

        <div class="mb-3">
          <p class="text-body-2 mb-3 fonted">New threshold</p>

          <v-row>
            <v-col class="my-0" cols="6">
              <v-text-field
                density="compact"
                color="primary"
                type="number"
                variant="outlined"
                placeholder="Threshold"
                v-model="input.threshold"
                :min="1"
                @input="$emit('input', 'threshold', input.threshold)"
                hide-details
              >
                <template v-slot:append>
                  <div>out of 1 owners</div>
                </template>
              </v-text-field>
            </v-col>
          </v-row>
        </div>

        <v-btn
          flat
          block
          class="mt-5"
          variant="flat"
          color="primary"
          @click="$emit('add', input)"
        >
          Add owner
        </v-btn>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script lang="ts" setup>
import { Safe } from "@/lib/entity";
import { watch, reactive } from "vue";

const event = defineEmits(["add", "toggle"]);
const props = defineProps<{ show: boolean; safe: Safe }>();

const input: { threshold: string; owner: string } = reactive({
  owner: "",
  threshold: "",
});

watch(
  () => props.safe,
  (safe) => (input.threshold = String(safe.threshold))
);

function toggleModal() {
  event("toggle", "add");
  input.owner = "";
}
</script>
