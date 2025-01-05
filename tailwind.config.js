/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./apps/web/**/*.{js,ts,jsx,tsx,mdx}",
    "./apps/docs/**/*.{js,ts,jsx,tsx,mdx}",
    // "./components/**/*.{js,ts,jsx,tsx,mdx}",
 
    // Or if using `src` directory:
    "./packages/ui/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}