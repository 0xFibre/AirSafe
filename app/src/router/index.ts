import { createRouter, createWebHistory } from "vue-router";
import CreateVallet from "@/views/vallet/Create.vue";
import Assets from "@/views/assets/Assets.vue";
import Owners from "@/views/owners/Owners.vue";

const routes = [
  {
    path: "/vallet/create",
    name: "CreateVallet",
    component: CreateVallet,
    meta: {
      hideSideBar: true,
    },
  },

  {
    path: "/assets",
    name: "Assets",
    component: Assets,
  },

  {
    path: "/owners",
    name: "Owners",
    component: Owners,
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
