<template>
  <v-window-item :value="window">
    <v-card-text>
      <h6 class="text-h6 font-weight-bold">Safe Details</h6>
      <p>Enter your Safe details</p>
    </v-card-text>

    <v-divider />

    <v-card-text>
      <div class="mb-8">
        <p class="text-body-1 mb-3 font-weight-bold">Safe Name</p>

        <v-text-field
          density="compact"
          color="primary"
          variant="outlined"
          placeholder="Safe name"
          v-model="input.name"
          @input="(e:any) => $emit('input', 'name', input.name)"
          hide-details
        />
      </div>

      <div class="mb-8">
        <p class="text-body-1 mb-3 font-weight-bold">Safe Owners</p>

        <v-text-field
          v-for="(member, i) of input.owners"
          :key="i"
          class="mb-3"
          density="compact"
          color="primary"
          prepend-icon="mdi-account-outline"
          variant="outlined"
          placeholder="Owner address"
          :model-value="member"
          @input="(e:any) => { input.owners[i] = e.target.value; $emit('input', `owners:${i}`, input.owners[i]) }"
          hide-details
        />

        <div class="d-flex">
          <v-spacer />

          <v-btn
            flat
            variant="text"
            density="compact"
            append-icon="mdi-plus"
            @click="(e:any) => { 
              let len = input.owners.length; 

              // @ts-expect-error
              input.owners[len] = ''; $emit('input', `owners:${len}`, '') 
            }"
          >
            Add owner
          </v-btn>
        </div>
      </div>

      <div class="mb-5">
        <div class="mb-3">
          <p class="text-body-1 font-weight-bold">Threshold</p>
          <p class="text-body-2">
            The minimum number of owners needed to approve any transaction
          </p>
        </div>

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
              :max="input.owners.length"
              @input="$emit('input', 'threshold', input.threshold)"
              hide-details
            >
              <template v-slot:append>
                <div>out of {{ input.owners.length }} owners</div>
              </template>
            </v-text-field>
          </v-col>
        </v-row>
      </div>
    </v-card-text>
  </v-window-item>
</template>

<script lang="ts" setup>
import { reactive } from "vue";

interface Input {
  name: string;
  threshold: string;
  owners: string[];
}

const props = defineProps<{ window: number; address: string }>();
const input: Input = reactive({
  name: "",
  owners: [props.address],
  threshold: "",
});

defineEmits(["input"]);
</script>
