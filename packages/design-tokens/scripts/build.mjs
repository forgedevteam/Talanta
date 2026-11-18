// Generates the Dart and CSS/Tailwind themes from tokens.json.
//
//   node scripts/build.mjs          write the generated files
//   node scripts/build.mjs --check  fail if the committed files are stale (used in CI)

import { mkdir, readFile, writeFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const tokens = JSON.parse(await readFile(join(root, 'tokens.json'), 'utf8'));

const HEX = /^#[0-9A-Fa-f]{6}$/;
const BANNER = 'GENERATED FILE — do not edit. Source: packages/design-tokens/tokens.json';

/** @param {string} hex @param {string} path */
function assertHex(hex, path) {
  if (!HEX.test(hex)) throw new Error(`${path}: expected #RRGGBB, got "${hex}"`);
  return hex.toUpperCase();
}

/** @param {string} name */
const kebab = (name) => name.replace(/[A-Z]/g, (c) => `-${c.toLowerCase()}`);

/** @param {string} hex */
const dartColor = (hex) => `Color(0xFF${hex.slice(1)})`;

function validate() {
  for (const group of ['brand', 'dark', 'light']) {
    for (const [name, hex] of Object.entries(tokens.color[group])) {
      tokens.color[group][name] = assertHex(hex, `color.${group}.${name}`);
    }
  }
  tokens.gradient.signature = tokens.gradient.signature.map((hex, i) =>
    assertHex(hex, `gradient.signature[${i}]`),
  );
  const darkKeys = Object.keys(tokens.color.dark).sort().join();
  const lightKeys = Object.keys(tokens.color.light).sort().join();
  if (darkKeys !== lightKeys) {
    throw new Error('color.dark and color.light must define the same roles');
  }
}

function renderCss() {
  const vars = (/** @type {Record<string, string>} */ group) =>
    Object.entries(group)
      .map(([name, hex]) => `  --talanta-${kebab(name)}: ${hex};`)
      .join('\n');

  const [from, to] = tokens.gradient.signature;
  return `/* ${BANNER} */

:root {
${vars(tokens.color.brand)}
${vars(tokens.color.dark)}
  --talanta-gradient-signature: linear-gradient(135deg, ${from}, ${to});
${Object.entries(tokens.radius)
  .map(([name, px]) => `  --talanta-radius-${name}: ${px}px;`)
  .join('\n')}
${Object.entries(tokens.motion)
  .map(([name, ms]) => `  --talanta-motion-${name}: ${ms}ms;`)
  .join('\n')}
  color-scheme: dark;
}

[data-theme='light'] {
${vars(tokens.color.light)}
  color-scheme: light;
}
`;
}

function renderTailwind() {
  const roles = [...Object.keys(tokens.color.brand), ...Object.keys(tokens.color.dark)];
  return `/* ${BANNER} */
/* Tailwind v4 theme. Import after "tailwindcss" and alongside tokens.css. */

@theme inline {
${roles.map((name) => `  --color-${kebab(name)}: var(--talanta-${kebab(name)});`).join('\n')}
${Object.entries(tokens.radius)
  .map(([name, px]) => `  --radius-${name}: ${px}px;`)
  .join('\n')}
  --spacing: ${tokens.spacing.x1}px;
  --font-display: var(--font-bricolage), '${tokens.font.display}', system-ui, sans-serif;
  --font-sans: var(--font-inter), '${tokens.font.body}', system-ui, sans-serif;
}
`;
}

function renderDart() {
  const paletteFields = Object.keys(tokens.color.dark);
  const palette = (/** @type {'dark' | 'light'} */ mode) =>
    `  static const TalantaPalette ${mode} = TalantaPalette(
${paletteFields.map((f) => `    ${f}: ${dartColor(tokens.color[mode][f])},`).join('\n')}
  );`;

  return `// ${BANNER}
// ignore_for_file: public_member_api_docs

import 'dart:ui';

/// Brand colours that stay the same in dark and light mode.
abstract final class TalantaBrand {
${Object.entries(tokens.color.brand)
  .map(([name, hex]) => `  static const Color ${name} = ${dartColor(hex)};`)
  .join('\n')}

  /// Sunset Orange to Deep Violet. Reserved for the logo, splash and record button.
  static const List<Color> signatureGradient = [
${tokens.gradient.signature.map((hex) => `    ${dartColor(hex)},`).join('\n')}
  ];
}

/// Mode-dependent colour roles.
final class TalantaPalette {
  const TalantaPalette({
${paletteFields.map((f) => `    required this.${f},`).join('\n')}
  });

${paletteFields.map((f) => `  final Color ${f};`).join('\n')}

${palette('dark')}

${palette('light')}
}

abstract final class TalantaRadii {
${Object.entries(tokens.radius)
  .map(([name, px]) => `  static const double ${name} = ${px};`)
  .join('\n')}
}

/// Spacing scale of ${tokens.spacing.x1}. \`x4\` is ${tokens.spacing.x4} logical pixels.
abstract final class TalantaSpacing {
${Object.entries(tokens.spacing)
  .map(([name, px]) => `  static const double ${name} = ${px};`)
  .join('\n')}
}

abstract final class TalantaDurations {
${Object.entries(tokens.motion)
  .map(([name, ms]) => `  static const Duration ${name} = Duration(milliseconds: ${ms});`)
  .join('\n')}
}

abstract final class TalantaFonts {
  static const String display = '${tokens.font.display.replaceAll(' ', '')}';
  static const String body = '${tokens.font.body.replaceAll(' ', '')}';
}
`;
}

validate();

const outputs = [
  ['generated/tokens.css', renderCss()],
  ['generated/tailwind.css', renderTailwind()],
  ['dart/lib/src/tokens.g.dart', renderDart()],
];

const check = process.argv.includes('--check');
let stale = false;

for (const [relative, content] of outputs) {
  const target = join(root, relative);
  if (check) {
    const current = await readFile(target, 'utf8').catch(() => '');
    if (current.replaceAll('\r\n', '\n') !== content) {
      console.error(`stale: ${relative} — run "pnpm tokens"`);
      stale = true;
    }
  } else {
    await mkdir(dirname(target), { recursive: true });
    await writeFile(target, content);
    console.log(`wrote ${relative}`);
  }
}

if (stale) process.exit(1);
if (check) console.log('design tokens are up to date');
