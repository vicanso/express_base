# 对于css中引入大图片的处理

修改grunt-image-embed的encode.js中exports.image中的complete的Toolog判断
```js
//MODIFY BY Tree 大于maxImageSize的图片，在url后面添加?v=xxx
var crypto = require('crypto');
var md5sum = crypto.createHash('md5');
encoded = img + '?v=' + md5sum.update(encoded).digest('hex');
// err = "Skipping " + img + " (greater than " + opts.maxImageSize + " bytes)";
```js