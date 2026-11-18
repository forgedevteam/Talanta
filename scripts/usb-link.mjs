/* global setInterval */
// Keeps every phone plugged in by USB pointed at the API on this PC.
// `adb reverse` is lost whenever the cable reconnects or adb restarts, and
// the app then reports "offline"; re-applying it every few seconds hides that.
import { execFile } from 'node:child_process';
import { existsSync } from 'node:fs';
import { join } from 'node:path';
import { promisify } from 'node:util';

const run = promisify(execFile);
const PORT = process.env.API_PORT ?? '3000';
const EVERY_MS = 3000;

function findAdb() {
  const sdk =
    process.env.ANDROID_HOME ??
    process.env.ANDROID_SDK_ROOT ??
    (process.env.LOCALAPPDATA && join(process.env.LOCALAPPDATA, 'Android', 'Sdk'));
  const exe = process.platform === 'win32' ? 'adb.exe' : 'adb';
  const candidate = sdk && join(sdk, 'platform-tools', exe);
  return candidate && existsSync(candidate) ? candidate : 'adb';
}

const adb = findAdb();
const linked = new Set();

async function tick() {
  let devices;
  try {
    const { stdout } = await run(adb, ['devices']);
    devices = stdout
      .split('\n')
      .slice(1)
      .map((line) => line.trim().split(/\s+/))
      .filter(([serial, state]) => serial && state === 'device')
      .map(([serial]) => serial);
  } catch (error) {
    console.error(`Could not run adb (${adb}): ${error.message}`);
    return;
  }

  for (const serial of devices) {
    try {
      const { stdout } = await run(adb, ['-s', serial, 'reverse', '--list']);
      if (stdout.includes(`tcp:${PORT}`)) continue;
      await run(adb, ['-s', serial, 'reverse', `tcp:${PORT}`, `tcp:${PORT}`]);
      console.log(`${new Date().toLocaleTimeString()}  ${serial} linked to port ${PORT}`);
      linked.add(serial);
    } catch {
      // The phone may be mid-reconnect or waiting for the USB debugging prompt.
    }
  }
  for (const serial of linked) {
    if (!devices.includes(serial)) {
      console.log(`${new Date().toLocaleTimeString()}  ${serial} unplugged; waiting for it`);
      linked.delete(serial);
    }
  }
}

console.log(`Keeping USB phones linked to http://localhost:${PORT}. Ctrl+C to stop.`);
await tick();
setInterval(tick, EVERY_MS);
