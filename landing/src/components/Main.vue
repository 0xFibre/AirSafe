import Hero from './Hero.vue';

<template>
  <Hero :appUrl="appUrl" />
  <AfterHero />
  <Why />
  <Try />
  <Footer />
</template>

<script lang="ts" setup>
import Hero from "./Hero.vue";
import AfterHero from "./AfterHero.vue";
import Why from "./Why.vue";
import Footer from "./Footer.vue";
import Try from "./Try.vue";

const appUrl = "https://app.airsafe.io";
</script>
