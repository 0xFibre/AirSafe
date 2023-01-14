<template>
  <v-window-item :value="window">
    <v-card-text>
      <h6 class="text-h6 font-weight-bold fonted">Vallet Details</h6>
      <p>Enter your Vallet details</p>
    </v-card-text>

    <v-divider />

    <v-card-text>
      <div class="mb-8">
        <p class="text-body-1 mb-3 font-weight-bold fonted">Vallet Name</p>

        <v-text-field
          density="comfortable"
          variant="outlined"
          placeholder="Vallet name"
          hide-details
        />
      </div>

      <div class="mb-8">
        <p class="text-body-1 mb-3 font-weight-bold fonted">Vallet Owners</p>

        <template v-for="owner in 4" :key="owner">
          <v-text-field
            class="mb-3"
            density="comfortable"
            prepend-icon="mdi-account-outline"
            variant="outlined"
            placeholder="Vallet name"
            hide-details
          />
        </template>

        <div class="d-flex">
          <v-spacer />

          <v-btn
            flat
            variant="text"
            density="comfortable"
            append-icon="mdi-plus"
          >
            Add owner
          </v-btn>
        </div>
      </div>

      <div class="mb-5">
        <div class="mb-3">
          <p class="text-body-1 font-weight-bold fonted">Threshold</p>
          <p class="text-body-2 fonted">
            The minimum number of owners needed to approve a transaction
          </p>
        </div>

        <v-select
          density="comfortable"
          variant="outlined"
          placeholder="Select Threshold"
          hide-details
        />
      </div>
    </v-card-text>
  </v-window-item>
</template>

<script lang="ts" setup>
defineProps<{ window: number }>();
</script>
