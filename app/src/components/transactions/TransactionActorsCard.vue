<template>
  <v-card border flat class="mb-3">
    <v-card-text class="d-flex">
      <h6 class="text-body-1 font-weight-bold">
        {{ action.charAt(0).toUpperCase() + action.slice(1) }}
      </h6>
      <v-spacer />
      <v-btn
        density="comfortable"
        flat
        :icon="show ? 'mdi-chevron-up' : 'mdi-chevron-down'"
        @click="$emit('toggle')"
      />
    </v-card-text>

    <v-divider />

    <v-expand-transition>
      <div v-show="show">
        <v-card-text>
          <v-list v-if="data.length > 0">
            <v-list-item v-for="address in data" :key="address">
              <template v-slot:prepend>
                <v-avatar size="25">
                  <v-img :src="makeBlockie(address)" />
                </v-avatar>
              </template>
              <v-list-item-title>{{ address }}</v-list-item-title>

              <template v-slot:append>
                <v-btn
                  flat
                  variant="text"
                  icon="mdi-open-in-new"
                  size="small"
                />
              </template>
            </v-list-item>
          </v-list>

          <Empty v-else :msg="`No ${action} for this transaction`" />
        </v-card-text>
      </div>
    </v-expand-transition>
  </v-card>
</template>

<script lang="ts" setup>
import makeBlockie from "ethereum-blockies-base64";
import Empty from "@/components/Empty.vue";

defineProps<{ data: string[]; action: string; show: boolean }>();
defineEmits(["toggle"]);
</script>
