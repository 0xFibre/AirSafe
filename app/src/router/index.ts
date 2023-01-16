import { createRouter, createWebHistory } from "vue-router";
import CreateSafe from "@/views/safe/Create.vue";
import Safes from "@/views/safe/Safes.vue";
import Coins from "@/views/assets/Coins.vue";
import Owners from "@/views/owners/Owners.vue";
import Transactions from "@/views/transaction/Transactions.vue";
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
    path: "/assets/coins",
    name: "Coins",
    component: Coins,
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

  {
    path: "/transactions",
    name: "Transactions",
    component: Transactions,
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
    if (!activeSafeId) return next({ name: "Safes" });
  }

  if (access === "auth" && !isConnected) return next({ name: "Connect" });
  if (access === "guest" && isConnected) return next({ name: "Owners" });

  return next();
});
