<template>
  <v-window-item :value="window">
    <v-card-text>
      <h6 class="text-h6 font-weight-bold">Approve Transaction</h6>
      <p>Approve the transaction to create your safe from your wallet</p>
    </v-card-text>

    <v-divider />

    <v-card-text>
      <div class="my-12 text-center">
        <v-icon
          size="100"
          v-if="status == 'neutral'"
          color="primary"
          icon="mdi-sync"
          class="mdi-spin"
        />

        <div v-if="status == 'success'">
          <v-icon size="100" color="success" icon="mdi-check-circle-outline" />
          <p class="text-subtitle-1 mt-3">Safe has been created succesfuly</p>
        </div>

        <div v-if="status == 'error'">
          <v-icon size="100" color="error" icon="mdi-close-circle-outline" />
          <p class="text-subtitle-1 mt-3">
            An error occured while creating safe
          </p>
        </div>
      </div>
    </v-card-text>
  </v-window-item>
</template>

<script lang="ts" setup>
defineProps<{ window: number; status: string }>();
</script>
