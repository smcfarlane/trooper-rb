/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./views/**/*.erb', './app/helpers/**/*.rb'],
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

