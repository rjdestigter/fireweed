module.exports = {
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js",
  ],
  theme: {
    extend: {
      fontFamily: {
        nutrition: ["Arial", "Helvetica", "sans-serif"],
        flaticon: ["Flaticon"],
      },
      borderWidth: {
        1: "1px",
        3: "3px",
        5: "5px",
        6: "6px",
        11: "11px",
      },
      outline: {
        nutrition: ["2px solid #616161", "-12px"],
      },
      colors: {
        primary: "rgb(255, 216, 21)", // "#11b955",
        secondary: "rgb(10, 255, 216)",
        "nutrition-grey": "#9e9e9e",
        nutrition: "#cccccc",
        white: {
          hard: "#000000",
          soft: "#cccccc",
          softer: "#a5a5a5",
          softest: "#6f6f6f",
        },
        black: {
          dark: "#1f1f1f",
          medium: "#282828",
          light: "#323232",
        },
      },
    },
  },
  variants: {},
  plugins: [],
};
