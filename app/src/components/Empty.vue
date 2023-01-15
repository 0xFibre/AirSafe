<template>
  <div class="text-center my-3">
    <p>{{ msg }}</p>
  </div>
</template>

<script lang="ts" setup>
defineProps<{ msg: string }>();
</script>
