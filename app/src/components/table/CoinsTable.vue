<template>
  <v-table hover fixed-header>
    <thead>
      <tr>
        <th>Name</th>
        <th>Balance</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="coin in coins" :key="coin.name">
        <td>
          <v-avatar size="20px" class="me-3">
            <v-img :src="coin.iconUrl" />
          </v-avatar>

          <p class="d-inline">{{ coin.name }}</p>
        </td>
        <td>{{ coin.balance }} {{ coin.symbol }}</td>
        <td class="text-right">
          <v-btn
            flat
            color="black"
            variant="tonal"
            class="me-1"
            density="comfortable"
            prepend-icon="mdi-arrow-bottom-left"
          >
            Deposit
          </v-btn>
          <v-btn
            flat
            color="black"
            variant="tonal"
            class="ms-1"
            density="comfortable"
            append-icon="mdi-arrow-top-right"
          >
            Send
          </v-btn>
        </td>
      </tr>
    </tbody>
  </v-table>
</template>

<script lang="ts" setup>
const coins = [
  {
    name: "Sui",
    symbol: "SUI",
    balance: 300,
    iconUrl: "https://s2.coinmarketcap.com/static/img/coins/64x64/20947.png",
  },
  {
    name: "Bitcoin",
    symbol: "BTC",
    balance: 20,
    iconUrl: "https://s2.coinmarketcap.com/static/img/coins/64x64/1.png",
  },
];
</script>

<style>
tr,
td {
  border: none !important;
  white-space: nowrap;
}
</style>
