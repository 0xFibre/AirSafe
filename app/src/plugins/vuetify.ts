import "@mdi/font/css/materialdesignicons.css";
import "vuetify/styles";

import { createVuetify } from "vuetify";

export const vuetify = createVuetify({
  theme: {
    // defaultTheme: "dark",
    themes: {
      light: {
        colors: {
          primary: "#0d4fe8",
          secondary: "#5CBBF6",
          background: "#f3f3f3",
        },
      },
      // dark: {
      //   colors: {
      //     background: "#1A1A1A",
      //     surface: "#202020",
      //   },
      // },
    },
  },
});
