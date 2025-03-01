// @ts-check
// `@type` JSDoc annotations allow editor autocompletion and type checking
// (when paired with `@ts-check`).
// There are various equivalent ways to declare your Docusaurus config.
// See: https://docusaurus.io/docs/api/docusaurus-config

import { themes as prismThemes } from "prism-react-renderer";

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: "Azure AI Lab",
  tagline:
    "Accelerate Your AI Journey: Explore Azure AI Services",
  url: "https://qkfang.github.io/",
  baseUrl: "/azure-ai-lab/",

  onBrokenLinks: "ignore",
  onBrokenMarkdownLinks: "ignore",
  trailingSlash: true,

  organizationName: "azure-ai-lab",
  projectName: "azure-ai-lab",
  deploymentBranch: "main",
  favicon: "img/favicon.ico",

  i18n: {
    defaultLocale: "en",
    locales: ["en"],
  },

  presets: [
    [
      "classic",
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          routeBasePath: "/",
          sidebarPath: require.resolve("./sidebars.js"),
        },
        blog: false,
        theme: {
          customCss: require.resolve("./src/css/custom.css"),
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      docs: {
        sidebar: {
          hideable: false,
          autoCollapseCategories: false,
        },
      },

      navbar: {
        title: "Explore Azure AI Services",
        logo: {
          alt: "Workshop: Explore Azure AI Services",
          src: "img/logo.png",
        },
        items: [
          {
            type: "localeDropdown",
            position: "right",
          },
        ],
      },

      footer: {
        style: "dark",
        links: [],
        copyright: `Copyright © ${new Date().getFullYear()} Learn how to interact with OpenAI models.`,
      },

      prism: {
        theme: prismThemes.github,
        darkTheme: prismThemes.dracula,
      },
    }),

  plugins: [
    [
      "@docusaurus/plugin-ideal-image",
      {
        quality: 96,
        max: 1000, // max resized image's size.
        min: 420, // min resized image's size.
        steps: 4, // #images b/w min and max (inclusive)
        disableInDev: false,
      },
    ],
  ],
};

module.exports = config;
