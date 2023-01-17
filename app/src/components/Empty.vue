<template>
  <div class="text-center text-disabled my-5">
    <p>{{ msg }}</p>
    <!-- <v-img src="/assets/empty.svg" height="100" /> -->
  </div>
</template>

<script lang="ts" setup>
defineProps<{ msg: string }>();
</script>
