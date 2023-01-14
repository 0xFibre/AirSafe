import { createRouter, createWebHistory } from "vue-router";
import CreateVallet from "@/views/vallet/Create.vue";

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
    ],
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
