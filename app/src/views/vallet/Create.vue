<template>
  <v-row>
    <v-col cols="12" sm="8" md="8" lg="6" class="mx-auto">
      <v-card flat>
        <v-progress-linear
          color="primary"
          :model-value="(state.window.value / state.window.total) * 100"
        />

        <v-window :model-value="state.window.value">
          <CreateInput :window="1" />
          <CreatePreview :window="2" />
          <CreateApprove :window="3" />
        </v-window>

        <v-card-text class="d-flex">
          <v-btn
            flat
            variant="outlined"
            prepend-icon="mdi-arrow-left"
            color="primary"
            @click="goBack"
          >
            Back
          </v-btn>

          <v-spacer />

          <v-btn
            flat
            variant="flat"
            append-icon="mdi-arrow-right"
            color="primary"
            @click="goNext"
          >
            Next
          </v-btn>
        </v-card-text>
      </v-card>
    </v-col>
  </v-row>
</template>

<script lang="ts" setup>
import CreateInput from "./create/Input.vue";
import CreatePreview from "./create/Preview.vue";
import CreateApprove from "./create/Approve.vue";
import { reactive } from "vue";

interface State {
  window: {
    value: number;
    total: number;
  };
}

const state: State = reactive({
  window: {
    value: 1,
    total: 3,
  },
});

function goNext() {
  if (state.window.value < state.window.total) {
    state.window.value = state.window.value + 1;
  }
}

function goBack() {
  if (state.window.value > 1) {
    state.window.value = state.window.value - 1;
  }
}
</script>

<style>
.fonted {
  font-family: Circular, sans-serif !important;
}
</style>
