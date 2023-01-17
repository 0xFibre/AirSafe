<template>
  <Loading v-if="state.loading" />
  <v-row v-else>
    <v-col cols="12" md="6">
      <v-card flat class="mb-5">
        <v-card-text>
          <h6 class="text-h6 font-weight-bold">Change safe name</h6>
        </v-card-text>

        <v-divider />

        <v-card-text>
          <p class="text-body-2 mb-3">Safe Name</p>
          <v-text-field color="primary" variant="outlined" density="compact" />

          <div class="d-flex">
            <v-spacer />
            <v-btn flat color="primary">Update</v-btn>
          </div>
        </v-card-text>
      </v-card>

      <v-card flat>
        <v-card-text>
          <h6 class="text-h6 font-weight-bold">Change Threshold</h6>
        </v-card-text>

        <v-divider />

        <v-card-text>
          <p class="text-body-2 mb-3">
            The minimum number of owners required to approve any transaction
          </p>

          <v-row>
            <v-col cols="6">
              <v-text-field
                type="number"
                color="primary"
                variant="outlined"
                density="compact"
                class="py-1"
                v-model="state.input.threshold"
                :min="1"
                :max="safe?.owners.length"
              >
                <template v-slot:append>
                  <div>out of {{ safe?.owners.length }} owners</div>
                </template>
              </v-text-field>
            </v-col>
          </v-row>

          <div class="d-flex">
            <v-spacer />
            <v-btn flat color="primary" @click="changeThreshold">Change</v-btn>
          </div>
        </v-card-text>
      </v-card>
    </v-col>
  </v-row>
</template>

<script lang="ts" setup>
import Loading from "@/components/Loading.vue";
import { useSafeStore } from "@/store";
import { storeToRefs } from "pinia";
import { onMounted, reactive } from "vue";

const safeStore = useSafeStore();
const { safe } = storeToRefs(safeStore);

interface State {
  loading: boolean;
  input: {
    threshold: string;
  };
}
const state: State = reactive({
  loading: false,
  input: {
    threshold: "",
  },
});

onMounted(async () => {
  try {
    state.loading = true;

    await loadData();
  } catch (e) {
    console.log(e);
  } finally {
    state.loading = false;
  }
});

async function loadData() {
  await safeStore.fetchActiveSafe();
  state.input.threshold = String(safe?.value?.threshold);
}

async function changeThreshold() {
  await safeStore.changeThresholdTransaction(state.input.threshold);
  await loadData();
}
</script>
