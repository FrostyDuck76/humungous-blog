const http = require('http');
const https = require('https');
const fs = require('fs');
const express = require('express');
const app = express();

const options = {
    key: fs.readFileSync('/etc/ssl/private/unified.key'),
    cert: fs.readFileSync('/etc/ssl/certs/unified.crt'),

    minVersion: 'TLSv1.2',
    maxVersion: 'TLSv1.3',

    ciphers: [
        'TLS_AES_256_GCM_SHA384',
        'ECDHE-RSA-AES256-GCM-SHA384'
    ].join(':'),
    honorCipherOrder: true
};

app.use(express.static('/var/www/html'));

https.createServer(options, app).listen(443, () => {
    console.log('HTTPS server running on port 443');
})