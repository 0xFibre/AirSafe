import { createRouter, createWebHistory } from "vue-router";
import CreateSafe from "@/views/safe/Create.vue";
import Safes from "@/views/safe/Safes.vue";
import Assets from "@/views/assets/Assets.vue";
import Owners from "@/views/owners/Owners.vue";
import Connect from "@/views/Connect.vue";
import { useConnectionStore, useSafeStore } from "@/store";

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
    path: "/safe/create",
    name: "CreateSafe",
    component: CreateSafe,
    meta: {
      access: "auth",
      hideSideBar: true,
    },
  },
  {
    path: "/safes",
    name: "Safes",
    component: Safes,
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
      access: "safe",
    },
  },

  {
    path: "/owners",
    name: "Owners",
    component: Owners,
    meta: {
      access: "safe",
    },
  },
];

export const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

router.beforeEach(async (to, _from, next) => {
  const { isConnected } = useConnectionStore();
  const { activeSafeId } = useSafeStore();
  const { access } = <{ access?: string }>to.meta;

  if (access === "safe") {
    if (!isConnected) return next({ name: "Connect" });
    if (!activeSafeId) return next({ name: "CreateSafe" });
  }

  if (access === "auth" && !isConnected) return next({ name: "Connect" });
  if (access === "guest" && isConnected) return next({ name: "Owners" });

  return next();
});
