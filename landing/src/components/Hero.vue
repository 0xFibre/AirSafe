<template>
  <v-container class="my-16">
    <v-row>
      <v-col cols="12" md="6">
        <h4
          class="text-h4 font-weight-bold mb-5 animate__animated animate__backInLeft"
        >
          Multisig standard for everyone on Sui
        </h4>

        <div class="text-body-1 mb-5 animate__animated animate__backInLeft">
          <p class="mb-3">
            State-of-the-art multisig standard, designed to provide maximum
            security and flexible access to all your crypto assets.
          </p>

          <p>- Built on <strong>Sui</strong></p>
        </div>

        <div class="d-flex">
          <v-btn
            append-icon="mdi-arrow-right"
            flat
            variant="tonal"
            color="primary"
            target="_blank"
            :href="appUrl"
          >
            Launch App
          </v-btn>
        </div>
      </v-col>

      <v-col cols="12" md="6">
        <v-img src="/images/connection.svg" height="350" />
      </v-col>
    </v-row>
  </v-container>
</template>

<script lang="ts" setup>
defineProps<{ appUrl: string }>();
</script>
