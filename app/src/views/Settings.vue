<template>
  <Loading v-if="state.loading" />
  <v-row v-else>
    <v-col cols="12" md="6">
      <v-card flat border class="mb-5">
        <v-card-text>
          <h6 class="text-h6 font-weight-bold">Change safe name</h6>
        </v-card-text>

        <v-divider />

        <v-card-text>
          <p class="text-body-2 mb-3">
            Safe Name (This is only stored on your device)
          </p>
          <v-text-field
            color="primary"
            variant="outlined"
            density="compact"
            v-model="state.input.safeName"
          />

          <div class="d-flex">
            <v-spacer />
            <v-btn flat color="primary" @click="changeSafeName">Update</v-btn>
          </div>
        </v-card-text>
      </v-card>

      <v-card flat border>
        <v-card-text>
          <h6 class="text-h6 font-weight-bold">Change Threshold</h6>
        </v-card-text>

        <v-divider />

        <v-card-text>
          <p class="text-body-2 mb-3">
            The minimum number of owners required to approve any transaction
          </p>

          <v-row>
            <v-col cols="8" md="6">
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
import { useRouter } from "vue-router";
import { useToast } from "vue-toastification";

const safeStore = useSafeStore();
const { safe } = storeToRefs(safeStore);

interface State {
  loading: boolean;
  input: {
    threshold: string;
    safeName: string;
  };
}

const toast = useToast();
const router = useRouter();
const state: State = reactive({
  loading: false,
  input: {
    threshold: "",
    safeName: "",
  },
});

onMounted(async () => {
  try {
    state.loading = true;
    await loadData();
  } catch (e) {
    toast.error(e.message);
  } finally {
    state.loading = false;
  }
});

async function loadData() {
  await safeStore.fetchActiveSafe();
  state.input.threshold = String(safe?.value?.threshold);
  state.input.safeName = safeStore.safeName(safe?.value?.id!);
}

async function changeThreshold() {
  try {
    const transaction = await safeStore.changeThresholdTransaction(
      state.input.threshold
    );
    router.push({ name: "Transaction", params: { id: transaction.id } });
  } catch (e) {
    toast.error(e.message);
  }
}

function changeSafeName() {
  safeStore.setSafeName(safe?.value?.id!, state.input.safeName);
}
</script>
