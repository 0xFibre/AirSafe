<template>
  <h5 class="text-h5 font-weight-bold fonted">Assets</h5>

  <div class="mb-3">
    <v-tabs color="primary">
      <v-tab>Coins</v-tab>
    </v-tabs>

    <v-divider />
  </div>

  <CoinsTable />
</template>

<style>
.fonted {
  font-family: Circular, sans-serif !important;
}
</style>

<script lang="ts" setup>
import CoinsTable from "@/components/table/CoinsTable.vue";
</script>
