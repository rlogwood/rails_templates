const { webpackConfig, merge } = require('@rails/webpacker')
const customConfig = {
    resolve: {
        extensions: ['.erb', '.scss', '.css']
    }
}

module.exports = merge(webpackConfig, customConfig)
