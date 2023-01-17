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
        @toggle="toggleModal('add')"
        @add="(input) => manageOwner('add', input)"
      />

      <RemoveOwner
        :safe="safe!"
        :show="state.remove.show"
        :owner="state.remove.owner"
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

const safeStore = useSafeStore();
const { safe } = storeToRefs(safeStore);

interface State {
  loading: boolean;
  add: {
    show: boolean;
  };
  remove: {
    show: boolean;
    owner: string;
  };
}
const state: State = reactive({
  loading: false,
  add: {
    show: false,
  },
  remove: {
    show: false,
    owner: "",
  },
});

onMounted(async () => {
  try {
    state.loading = true;
    await safeStore.fetchActiveSafe();
  } catch (e) {
    console.log(e);
  } finally {
    state.loading = false;
  }
});

function toggleModal(action: "add" | "remove", owner?: string) {
  state[action].show = !state[action].show;
  (<{ owner?: string }>state[action]).owner = owner;
}

async function manageOwner(
  type: "add" | "remove",
  input: { owner: string; threshold: string }
) {
  await safeStore.manageOwnerTransaction({ ...input, type });
}
</script>
