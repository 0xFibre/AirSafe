<template>
  <Loading v-if="state.loading" />
  <v-row v-else>
    <v-col cols="12" md="8" class="mx-auto">
      <div class="d-flex mb-3">
        <h6 class="text-h6 font-weight-bold">Safes</h6>
        <v-spacer />
        <v-btn
          flat
          variant="text"
          density="comfortable"
          prepend-icon="mdi-plus"
          to="/safe/create"
        >
          Create safe
        </v-btn>
      </div>

      <Empty v-if="safes.length < 1" msg="You do not own any safe" />

      <template v-else>
        <v-list-item
          v-for="safe in safes"
          :key="safe.id"
          lines="two"
          border
          class="my-2"
          :prepend-avatar="makeBlockie(safe.id)"
        >
          <v-list-item-title>
            {{
              safeStore.safeName(safe.id)
                ? `${safeStore.safeName(safe.id)} (${utils.truncate0x(
                    safe.id
                  )})`
                : utils.truncate0x(safe.id)
            }}
          </v-list-item-title>

          <v-list-item-action>
            <v-btn flat variant="text" icon="mdi-qrcode" size="x-small" />
            <v-btn flat variant="text" icon="mdi-content-copy" size="x-small" />
            <v-btn
              flat
              target="_blank"
              :href="`${env.suiExplorerUrl}/object/${safe.id}?network=${env.suiNetwork}`"
              variant="text"
              icon="mdi-open-in-new"
              size="x-small"
            />
          </v-list-item-action>

          <template v-slot:append>
            <v-btn
              flat
              variant="text"
              density="comfortable"
              append-icon="mdi-arrow-right"
              @click="setActiveSafe(safe.id)"
            >
              open
            </v-btn>
          </template>
        </v-list-item>
      </template>
    </v-col>
  </v-row>
</template>

<script lang="ts" setup>
import { env } from "@/config";
import { useSafeStore } from "@/store";
import { storeToRefs } from "pinia";
import { onMounted, reactive } from "vue";
import makeBlockie from "ethereum-blockies-base64";
import Empty from "@/components/Empty.vue";
import { useRouter } from "vue-router";
import Loading from "@/components/Loading.vue";
import { utils } from "@/utils";
import { useToast } from "vue-toastification";

const safeStore = useSafeStore();
const router = useRouter();
const toast = useToast();
const { safes } = storeToRefs(safeStore);

const state: { loading: boolean } = reactive({ loading: false });

onMounted(async () => {
  try {
    state.loading = true;
    await safeStore.fetchSafes();
  } catch (e) {
    toast.error(e.message);
  } finally {
    state.loading = false;
  }
});

function setActiveSafe(id: string) {
  safeStore.setActiveSafeId(id);
  router.push({ name: "Dashboard" });
}
</script>
