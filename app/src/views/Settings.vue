<template>
  <v-row>
    <v-col cols="12" md="6">
      <v-card flat class="mb-5">
        <v-card-text>
          <h6 class="text-h6 font-weight-bold fonted">Change safe name</h6>
        </v-card-text>

        <v-divider />

        <v-card-text>
          <p class="text-body-2 fonted mb-3">Safe Name</p>
          <v-text-field color="primary" variant="outlined" density="compact" />

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
          <p class="text-body-2 fonted mb-3">
            The minimum number of owners required to approve any transaction
          </p>

          <v-row>
            <v-col cols="6">
              <v-text-field
                type="number"
                color="primary"
                variant="outlined"
                density="compact"
                class="py-1"
              >
                <template v-slot:append>
                  <div>out of 1 owners</div>
                </template>
              </v-text-field>
            </v-col>
          </v-row>

          <div class="d-flex">
            <v-spacer />
            <v-btn flat color="primary">Change</v-btn>
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
