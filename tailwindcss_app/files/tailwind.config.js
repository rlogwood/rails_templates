const colors = require('./node_modules/tailwindcss/colors');
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
    purge: [],
    darkMode: false, // or 'media' or 'class'
    theme: {
        extend: {
            colors: {
                rose: colors.rose,
                fuchsia: colors.fuchsia,
                indigo: colors.indigo,
                teal: colors.teal,
                lime: colors.lime,
                orange: colors.orange,
            },
            fontFamily: {
                sans: ['Inter var', ...defaultTheme.fontFamily.sans],
            },
        },
    },
    variants: {
        extend: {},
    },
    plugins: [
        require('@tailwindcss/typography'),
        require('@tailwindcss/forms')
    ],
}
