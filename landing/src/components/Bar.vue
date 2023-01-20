<template>
  <!-- <v-navigation-drawer temporary v-model="drawer">
    <v-list nav>
      <v-list-item prepend-icon="mdi-arrow-right">
        <v-list-item-title>Go to app</v-list-item-title>
      </v-list-item>
    </v-list>
  </v-navigation-drawer> -->

  <v-app-bar flat>
    <v-container class="fill-height d-flex align-center">
      <!-- <v-app-bar-nav-icon class="d-block d-md-none" @click="drawer = !drawer" /> -->

      <v-app-bar-title>
        <h6 class="no-select text-h6 font-weight-bold">AirSafe</h6>
      </v-app-bar-title>

      <v-spacer />

      <v-btn
        flat
        variant="flat"
        color="primary"
        append-icon="mdi-arrow-right"
        target="_blank"
        href="https://app.airsafe.io"
      >
        Go to app
      </v-btn>
    </v-container>
  </v-app-bar>
</template>

<script lang="ts" setup>
import { Ref, ref } from "vue";

const drawer: Ref<boolean | null> = ref(null);
</script>
