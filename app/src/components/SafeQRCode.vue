<template>
  <v-dialog :model-value="show" persistent max-width="550px">
    <v-card>
      <v-card-text class="d-flex">
        <h6 class="text-h6 font-weight-bold">Safe ID</h6>

        <v-spacer />

        <v-btn
          flat
          density="comfortable"
          icon="mdi-close"
          @click="$emit('toggle')"
        />
      </v-card-text>

      <v-divider />

      <v-card-text class="mb-6">
        <p class="text-body-2 mb-3">
          This is your Safe ID. Do not send funds or assets to this it directly
          or they will be lost.
        </p>

        <p class="text-body-2 mb-3">
          Please use the deposit button on the assets page to add assets
        </p>

        <v-sheet
          id="qrContainer"
          class="my-5 mx-auto"
          max-width="202px"
          max-height="202px"
          border
        />

        <div class="d-flex align-center text-body-2">
          <p>{{ id }}</p>

          <v-spacer />

          <v-btn flat variant="text" icon="mdi-content-copy" size="x-small" />
          <v-btn flat variant="text" icon="mdi-open-in-new" size="x-small" />
        </div>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script lang="ts" setup>
// @ts-nocheck
import qrcode from "qrcode";
import { watch } from "vue";

const props = defineProps<{ show: boolean; id: string }>();
defineEmits(["toggle"]);

watch(
  () => props.show,
  async (show) => {
    if (!show) return;

    const cv = await qrcode.toCanvas(props.id, {
      quality: 1,
      width: 200,
      color: { dark: "#000000" },
    });

    const qs = document.querySelector("#qrContainer");
    if (qs) qs.appendChild(cv);
  }
);
</script>

<style>
canvas {
  display: block;
  margin: 0 auto;
}
</style>
