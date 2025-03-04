// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/swai_web.ex",
    "../lib/swai_web/**/*.*ex"
  ],
  theme: {
    screens: {
      '2xl': {'max': '1535px'},
      // => @media (max-width: 1535px) { ... }

      'xl': {'max': '1279px'},
      // => @media (max-width: 1279px) { ... }

      'lg': {'max': '1023px'},
      // => @media (max-width: 1023px) { ... }

      'md': {'max': '767px'},
      // => @media (max-width: 767px) { ... }

      'sm': {'max': '639px'},
      // => @media (max-width: 639px) { ... }
    },
    extend: {
      colors: {
        swBrand: {
          dark: "#00A1FE",
          DEFAULT: "#00CECA",
          light: "#00FE70"
        },
        ltDark: {
          dark: "#010101",
          DEFAULT: "#000000",
          light: "#828282"
        },
        ltTurquoise: {
          dark: "#004040",
          DEFAULT: "#007575",          
          light: "#40E0D0"
        },
        ltLavender: {
          dark: "#8C55FF",
          DEFAULT: "#9D74EE",
          light: "#BC9AFF"
        },
        ltOrange: {
          dark: "#FD4F00",
          DEFAULT: "#FF6F00",
          light: "#FAA523"
        },
        ltRed: {
          dark: "#FF0000",
          DEFAULT: "#FF0000",
          light: "#FF8080"
        },
        ltOlive: {
          dark: "#437A5F",
          DEFAULT: "#5B9C7A",
          light: "#7DC29A"
        },
        ltSilver: {
          dark: "#536B78",
          DEFAULT: "#7C98B3",
          light: "#ACCBE1"
        },
        ltGold: {
          dark: "##4f4c15",
          DEFAULT: "#FFD700",
          light: "##ebe694"
        },
        ltGreen: {
          dark: "#063820",
          DEFAULT: "#008000",
          light: "#65ebaa"
        },
        ltBlue: {
          dark: "#0000FF",
          DEFAULT: "#0000FF",
          light: "#0000FF"
        },
        ltPurple: {
          dark: "##4b1257",
          DEFAULT: "#801f94",
          light: "##d852f2"          
        },
        ltIndigo: {
          dark: "##2b0a59",
          DEFAULT: "##532594",
          light: "##9552f2"
        },
      },
      fontFamily: {
        brand: ["WorkSans", "sans-serif"],
        mono: ["Anonymous Pro", "monospace"]
      },
      fontWeight: {
        regular: "normal",
        bold: "bold",
        light: 300,
        normal: 400,
        medium: 500,
        semibold: 600,
        bold: 700
      },
    }
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({ addVariant }) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({ addVariant }) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({ addVariant }) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function ({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, "../../../deps/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) }
        })
      })
      matchComponents({
        "hero": ({ name, fullPath }) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          let size = theme("spacing.6")
          if (name.endsWith("-mini")) {
            size = theme("spacing.5")
          } else if (name.endsWith("-micro")) {
            size = theme("spacing.4")
          }
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": size,
            "height": size
          }
        }
      }, { values })
    })
  ]
}
