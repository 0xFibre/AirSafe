<template>
  <v-sheet class="py-10">
    <v-container>
      <h4 class="text-h4 text-center mb-10 font-weight-bold">Why AirSafe?</h4>

      <v-row>
        <template v-for="(d, i) in data" :key="i">
          <v-col class="my-0" cols="12" sm="6">
            <div class="d-flex">
              <v-avatar variant="tonal" color="black" class="me-3">
                <v-icon :icon="d.icon" />
              </v-avatar>

              <div class="">
                <p class="mb-2 font-weight-bold">{{ d.title }}</p>
                <p>{{ d.text }}</p>
              </div>
            </div>
          </v-col>
        </template>
      </v-row>
    </v-container>
  </v-sheet>
</template>

<script lang="ts" setup>
const data = [
  {
    title: "Multi-Signature",
    icon: "mdi-vector-circle",
    text: "You can configure your Safe to require a predefined number of signatures to approve transactions. This helps eliminate single point of failure and unauthorized access to your assets.",
  },
  {
    title: "Shared Ownership",
    icon: "mdi-account-multiple",
    text: "Safe ownership is shared. This enable teams, DAO members and any group of people to own and manage their assets together.",
  },
  {
    title: "Secure",
    icon: "mdi-security",
    text: "In addition to the security of Sui and Move, We implement protocol level security to ensure that Safes and assets they hold are never compromised.",
  },
  {
    title: "Open Source",
    icon: "mdi-source-fork",
    text: "We believe in open source and transparency. So, Our code are publicly available on GitHub. We also believe that this will benefit the Sui ecosystem.",
  },
];
</script>
