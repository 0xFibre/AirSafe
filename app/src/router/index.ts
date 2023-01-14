import { createRouter, createWebHistory } from "vue-router";
import CreateVallet from "@/views/vallet/Create.vue";
import Assets from "@/views/assets/Assets.vue";

const routes = [
  {
    path: "/",
    component: () => import("@/layouts/default/Default.vue"),
    children: [
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
    ],
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
