<template>
  <Loading v-if="state.loading" />
  <v-row v-else>
    <v-col cols="12" md="8" class="mx-auto">
      <div class="d-flex mb-3 justify-space-between">
        <h6 class="text-h6 font-weight-bold">Owners</h6>

        <v-btn
          flat
          variant="text"
          density="comfortable"
          @click="toggleModal('add')"
        >
          Add new owner
        </v-btn>
      </div>
      <OwnersList
        :owners="safe?.owners"
        @remove="(owner) => toggleModal('remove', owner)"
      />

      <AddOwnerModal
        :safe="safe!"
        :show="state.add.show"
        :submitting="state.add.submitting"
        @toggle="toggleModal('add')"
        @add="(input) => manageOwner('add', input)"
      />

      <RemoveOwner
        :safe="safe!"
        :show="state.remove.show"
        :owner="state.remove.owner"
        :submitting="state.remove.submitting"
        @toggle="(owner) => toggleModal('remove', owner)"
        @remove="(input) => manageOwner('remove', input)"
      />
    </v-col>
  </v-row>
</template>

<script lang="ts" setup>
import { useSafeStore } from "@/store";
import { storeToRefs } from "pinia";
import { onMounted, reactive } from "vue";
import OwnersList from "@/components/owners/OwnersList.vue";
import AddOwnerModal from "@/components/owners/AddOwnerModal.vue";
import RemoveOwner from "@/components/owners/RemoveOwner.vue";
import Loading from "@/components/Loading.vue";
import { useToast } from "vue-toastification";

const toast = useToast();
const safeStore = useSafeStore();
const { safe } = storeToRefs(safeStore);

interface State {
  loading: boolean;
  add: {
    show: boolean;
    submitting: boolean;
  };
  remove: {
    show: boolean;
    owner: string;
    submitting: boolean;
  };
}
const state: State = reactive({
  loading: false,
  add: {
    show: false,
    submitting: false,
  },
  remove: {
    show: false,
    owner: "",
    submitting: false,
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
}

function toggleModal(action: "add" | "remove", owner?: string) {
  state[action].show = !state[action].show;
  (<{ owner?: string }>state[action]).owner = owner;
}

async function manageOwner(
  type: "add" | "remove",
  input: { owner: string; threshold: string }
) {
  try {
    state[type].submitting = true;
    await safeStore.manageOwnerTransaction({ ...input, type });
    await loadData();
  } catch (e) {
    toast.error(e.message);
  } finally {
    state[type].submitting = false;
  }
}
</script>
