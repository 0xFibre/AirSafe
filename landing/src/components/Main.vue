import Hero from './Hero.vue';

<template>
  <Hero :appUrl="appUrl" />
  <AfterHero />
  <Why />
  <Developer />
  <Try />
  <Footer />
</template>

<script lang="ts" setup>
import Hero from "./Hero.vue";
import AfterHero from "./AfterHero.vue";
import Why from "./Why.vue";
import Footer from "./Footer.vue";
import Try from "./Try.vue";
import Developer from "./Developer.vue";

const appUrl = "https://app.airsafe.io";
</script>
