<template>
  <v-sheet class="py-10" color="primary" rounded>
    <v-container>
      <div class="mb-5">
        <h4 class="text-h4 font-weight-bold mb-3 text-center">Features</h4>
        <p class="text-emphasis-medium">AirSafe</p>
      </div>

      <ul>
        <li class="my-2 d-flex align-center" v-for="text in texts">
          <v-icon size="small" icon="mdi-check-circle" class="me-3" />
          <span>{{ text }}</span>
        </li>
      </ul>
    </v-container>
  </v-sheet>
</template>

<script lang="ts" setup>
const texts = ["Coins Management", "NFTs Management", "Ownership control"];
</script>

<style scoped>
ul {
  list-style: none;
  padding: 0;
}
</style>
