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
            <span>Test Safe</span>
          </v-col>
        </v-row>
      </div>

      <div class="mb-3">
        <v-row>
          <v-col cols="4">
            <span>Owners</span>
          </v-col>
          <v-col cols="8">
            <p>0x86eb72826D22Cb3Bf051686E2dA433da202712Eb</p>
            <p>0x86eb72826D22Cb3Bf051686E2dA433da202712Eb</p>
            <p>0x86eb72826D22Cb3Bf051686E2dA433da202712Eb</p>
          </v-col>
        </v-row>
      </div>

      <div class="mb-3">
        <v-row>
          <v-col cols="4">
            <span>Threshold</span>
          </v-col>
          <v-col cols="8">
            <span>3</span>
          </v-col>
        </v-row>
      </div>
    </v-card-text>
  </v-window-item>
</template>

<script lang="ts" setup>
defineProps<{ window: number }>();
</script>
