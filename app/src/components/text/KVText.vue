<template>
  <div class="my-3 d-flex">
    <span>{{ title }}</span>
    <v-spacer />
    <span>{{ value }}</span>
  </div>
</template>

<script lang="ts" setup>
defineProps<{ title: string; value: string }>();
</script>
