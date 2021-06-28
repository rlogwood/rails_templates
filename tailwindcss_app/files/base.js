const { webpackConfig, merge } = require('@rails/webpacker')
const customConfig = {
    resolve: {
        extensions: ['.scss', '.css']
    }
}

module.exports = merge(webpackConfig, customConfig)
