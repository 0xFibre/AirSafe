<template>
  <div class="mb-3">
    <h6 class="text-h6 font-weight-bold">{{ title }}</h6>
  </div>
</template>

<script lang="ts" setup>
defineProps<{ title: string }>();
</script>
