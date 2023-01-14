import { createRouter, createWebHistory } from "vue-router";
import CreateVallet from "@/views/vallet/Create.vue";
import Vallets from "@/views/vallet/Vallets.vue";
import Assets from "@/views/assets/Assets.vue";
import Owners from "@/views/owners/Owners.vue";
import Connect from "@/views/Connect.vue";
import { useConnectionStore } from "@/store";

const routes = [
  {
    path: "/connect",
    name: "Connect",
    component: Connect,
    meta: {
      access: "guest",
      hideSideBar: true,
      hideAppBar: true,
    },
  },
  {
    path: "/vallet/create",
    name: "CreateVallet",
    component: CreateVallet,
    meta: {
      access: "auth",
      hideSideBar: true,
    },
  },
  {
    path: "/vallets",
    name: "Vallets",
    component: Vallets,
    meta: {
      access: "auth",
      hideSideBar: true,
    },
  },

  {
    path: "/assets",
    name: "Assets",
    component: Assets,
    meta: {
      access: "auth",
    },
  },

  {
    path: "/owners",
    name: "Owners",
    component: Owners,
    meta: {
      access: "auth",
    },
  },
];

export const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

router.beforeEach(async (to, _from, next) => {
  const { isConnected } = useConnectionStore();
  const { access } = <{ access?: string }>to.meta;

  if (access === "auth" && !isConnected) {
    return next({ name: "Connect" });
  }

  if (access === "guest" && isConnected) {
    return next({ name: "Owners" });
  }

  return next();
});
