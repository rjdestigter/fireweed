module.exports = {
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js",
  ],
  variants: {
    textColor: ["responsive", "hover", "focus", "focus-within"],
  },
  theme: {
    extend: {
      fontFamily: {
        nutrition: ["Arial", "Helvetica", "sans-serif"],
        flaticon: ["Flaticon"],
        quicksand: ["Quicksand", "sans-serif"],
        roboto: ["Roboto Slab", "sans-serif"],
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
        textfield: {
          label: "#676767",
          border: "#383838",
        },
        white: {
          hard: "#000000",
          soft: "#cccccc",
          softer: "#a5a5a5",
          softest: "#6f6f6f",
        },
        black: {
          dark: "#131001",
          medium: "#282828",
          light: "#323232",
        },
      },
    },
  },
  plugins: [],
};
