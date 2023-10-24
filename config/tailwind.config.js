/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './views/**/*.haml',
    './helpers/**/*.rb',
    './components/**/*.rb',
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/container-queries'),
  ],
}

