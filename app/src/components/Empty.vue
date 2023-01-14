<template>
  <div class="text-center">
    <p>{{ msg }}</p>
  </div>
</template>

<script lang="ts" setup>
defineProps<{ msg: string }>();
</script>
