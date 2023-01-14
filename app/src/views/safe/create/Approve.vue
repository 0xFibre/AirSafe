<template>
  <v-window-item :value="window">
    <v-card-text>
      <h6 class="text-h6 font-weight-bold fonted">Approve Transaction</h6>
      <p>Approve the transaction to create your safe in your wallet</p>
    </v-card-text>

    <v-divider />

    <v-card-text>
      <p class="text-center">Approving....</p>
    </v-card-text>
  </v-window-item>
</template>

<script lang="ts" setup>
defineProps<{ window: number }>();
</script>
