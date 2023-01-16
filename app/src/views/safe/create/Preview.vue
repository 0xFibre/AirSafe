<template>
  <v-window-item :value="window">
    <v-card-text>
      <h6 class="text-h6 font-weight-bold fonted">Review</h6>
      <p>Review your Safe details. Go back if you need to make adjustments</p>
    </v-card-text>

    <v-divider />

    <v-card-text>
      <div class="mb-3">
        <v-row>
          <v-col cols="4">
            <span>Name</span>
          </v-col>
          <v-col cols="8">
            <span>{{ input.name }}</span>
          </v-col>
        </v-row>
      </div>

      <div class="mb-3">
        <v-row>
          <v-col cols="4">
            <span>Owners</span>
          </v-col>

          <v-col cols="8">
            <template v-for="owner in input.owners">
              <div class="d-flex justify-space-between align-center my-0 py-0">
                <div class="d-flex align-center">
                  <v-avatar size="15" class="me-3">
                    <v-img :src="makeBlockie(owner)" />
                  </v-avatar>
                  <p>{{ utils.truncate0x(owner) }}</p>
                </div>

                <div>
                  <v-btn
                    flat
                    variant="text"
                    icon="mdi-open-in-new"
                    size="x-small"
                  />
                </div>
              </div>
            </template>
          </v-col>
        </v-row>
      </div>

      <div class="mb-3">
        <v-row>
          <v-col cols="4">
            <span>Threshold</span>
          </v-col>

          <v-col cols="8">
            <span>{{ input.threshold }}</span>
          </v-col>
        </v-row>
      </div>
    </v-card-text>
  </v-window-item>
</template>

<script lang="ts" setup>
import { utils } from "@/utils";
import makeBlockie from "ethereum-blockies-base64";

defineProps<{
  window: number;
  input: {
    name?: string;
    threshold: string;
    owners: string[];
  };
}>();
</script>
