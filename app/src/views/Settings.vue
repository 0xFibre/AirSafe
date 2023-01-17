<template>
  <v-row>
    <v-col cols="12" md="6">
      <v-card flat class="mb-3">
        <v-card-text>
          <p class="text-body-2 fonted mb-3">Safe Name</p>
          <v-text-field variant="outlined" density="comfortable" />

          <div class="d-flex">
            <v-spacer />
            <v-btn flat color="primary">Update</v-btn>
          </div>
        </v-card-text>
      </v-card>

      <v-card flat>
        <v-card-text>
          <h6 class="text-h6 font-weight-bold fonted">Change Threshold</h6>
        </v-card-text>

        <v-divider />

        <v-card-text>
          <p class="text-body-2 fonted mb-3">Threshold</p>
          <v-select variant="outlined" density="comfortable" />

          <div class="d-flex">
            <v-spacer />
            <v-btn flat color="primary">Update</v-btn>
          </div>
        </v-card-text>
      </v-card>
    </v-col>
  </v-row>
</template>

<style scoped>
.fonted {
  font-family: Circular, sans-serif !important;
}
</style>
