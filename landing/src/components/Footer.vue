<template>
  <v-sheet color="primary" class="py-5">
    <v-container>
      <div class="d-flex align-center justify-space-center">
        <div class="mb-3">
          <h6 class="text-h6 font-weight-bold">AirSafe</h6>
          <p class="text-body-2">&copy; {{ new Date().getFullYear() }}</p>
        </div>
        <v-spacer />
        <div class="d-flex align-center" style="gap: 5px">
          <v-btn
            density="compact"
            variant="text"
            size="small"
            icon="mdi-twitter"
            href="https://twitter.com/AirSafeProtocol"
            target="_blank"
          />
        </div>
      </div>
    </v-container>
  </v-sheet>
</template>
