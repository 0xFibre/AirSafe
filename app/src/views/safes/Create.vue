<template>
  <v-row>
    <v-col cols="12" sm="8" md="8" lg="6" class="mx-auto">
      <v-card flat border>
        <v-progress-linear
          color="primary"
          :model-value="(state.window.value / state.window.total) * 100"
        />

        <v-window :model-value="state.window.value">
          <CreateInput :window="1" @input="updateInput" :address="address" />
          <CreatePreview :window="2" :input="state.input" />
          <CreateApprove :window="3" :status="state.status" />
        </v-window>

        <v-card-text class="d-flex">
          <v-btn
            flat
            variant="outlined"
            prepend-icon="mdi-arrow-left"
            color="primary"
            :disabled="state.submitting"
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
            :disabled="state.submitting"
            @click="goNext"
          >
            {{
              state.status == "error"
                ? "Try again?"
                : state.window.value == state.window.total
                ? "Create"
                : "Next"
            }}
          </v-btn>
        </v-card-text>
      </v-card>
    </v-col>
  </v-row>
</template>

<script lang="ts" setup>
import { reactive } from "vue";
import CreateInput from "./create/Input.vue";
import CreatePreview from "./create/Preview.vue";
import CreateApprove from "./create/Approve.vue";
import { useVuelidate } from "@vuelidate/core";
import { required, between } from "@vuelidate/validators";
import { useSafeStore, useConnectionStore } from "@/store";
import { storeToRefs } from "pinia";
import { useToast } from "vue-toastification";
import { useRouter } from "vue-router";

interface State {
  window: {
    value: number;
    total: number;
  };
  input: {
    name: string;
    owners: string[];
    threshold: string;
  };
  submitting: boolean;
  status: string;
}

const safeStore = useSafeStore();
const connectionStore = useConnectionStore();

const { address } = storeToRefs(connectionStore);

const state: State = reactive({
  window: {
    value: 1,
    total: 3,
  },
  input: {
    name: "",
    owners: [address.value],
    threshold: "1",
  },
  submitting: false,
  status: "neutral",
});

const rules = {
  threshold: {
    required,
    betweenValue: between(1, state.input.owners.length + 1),
  },
  owners: {
    required,
    $each: {
      required,
    },
  },
};

const $v = useVuelidate(rules, state.input);
const toast = useToast();
const router = useRouter();

async function createSafe() {
  try {
    state.submitting = true;
    if (await $v.value.$validate()) {
      const payload = {
        threshold: state.input.threshold,
        name: state.input.name,
        owners: state.input.owners.filter((member) => !!member),
      };

      await safeStore.createSafe(payload);

      state.status = "success";
      router.push({ name: "Dashboard" });
    }
  } catch (e) {
    state.status = "error";
    toast.error(e.message);
  } finally {
    state.submitting = false;
  }
}

function updateInput(key: string, value: string) {
  if (key.startsWith("owners:")) {
    const [k, i] = key.split(":");

    // @ts-expect-error
    state.input[k][i] = value;
  } else {
    // @ts-expect-error
    state.input[key] = value;
  }
}

async function goNext() {
  if (state.window.value < state.window.total) {
    state.window.value = state.window.value + 1;
  } else {
    await createSafe();
  }
}

function goBack() {
  if (state.window.value > 1) {
    state.window.value = state.window.value - 1;
  }
}
</script>
