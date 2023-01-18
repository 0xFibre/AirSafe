<template>
  <v-menu :activator="activator" location="bottom">
    <v-list density="comfortable">
      <v-list-item
        v-for="(item, index) in items"
        :key="index"
        :value="index"
        @click="item.function"
      >
        <template v-slot:prepend>
          <v-icon :icon="item.icon" />
        </template>
        <v-list-item-title>{{ item.title }}</v-list-item-title>
      </v-list-item>
    </v-list>
  </v-menu>
</template>

<script lang="ts" setup>
defineProps<{
  activator: string;
  items: { title: string; icon: string; function?: Function }[];
}>();
</script>
