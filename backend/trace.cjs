const { nodeFileTrace } = require('@vercel/nft');
const path = require('path');

async function check() {
    try {
        const { fileList, warnings } = await nodeFileTrace(['./index.js']);
        console.log('Trace successful. Files found:', fileList.length);
        if (warnings.size > 0) {
            console.log('Warnings:', warnings);
        }
    } catch (err) {
        console.error('TRACE ERROR:', err);
    }
}

check();
