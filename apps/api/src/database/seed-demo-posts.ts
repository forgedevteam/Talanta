import { mkdir, writeFile } from 'node:fs/promises';
import { dirname, join, resolve } from 'node:path';

import { eq, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import sharp from 'sharp';

import { uuidv7 } from '../common/ids/uuidv7.js';
import type * as schema from './schema/index.js';
import { comments, media, notifications, postLikes, postMedia, posts } from './schema/index.js';

// Demo posts: event flyers and artwork drawn here as SVG, plus words and a
// conversation, so the feed looks lived in on first launch. Pictures of
// people are left to real members.

type Db = NodePgDatabase<typeof schema>;

const HOUR = 3_600_000;
const KENTE = ['#F5B700', '#FF6B2C', '#6C2BD9', '#3A2A12'];

const kente = (y: number, width: number, height = 18): string =>
  Array.from({ length: Math.ceil(width / 36) }, (_, i) => {
    const color = KENTE[i % KENTE.length] ?? '#F5B700';
    return `<rect x="${i * 36}" y="${y}" width="36" height="${height}" fill="${color}"/>`;
  }).join('');

const escape = (text: string): string =>
  text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

interface Flyer {
  kicker: string;
  title: string[];
  lines: string[];
  from: string;
  to: string;
  accent: string;
}

/** A 4:5 event flyer in the style people share on WhatsApp and Facebook. */
function flyer(f: Flyer): string {
  const w = 1080;
  const h = 1350;
  const title = f.title
    .map(
      (line, i) =>
        `<text x="80" y="${470 + i * 150}" font-family="Arial Black, Arial, sans-serif" font-weight="900" font-size="140" fill="#FFFFFF" letter-spacing="-4">${escape(line)}</text>`,
    )
    .join('');
  const lines = f.lines
    .map(
      (line, i) =>
        `<text x="80" y="${940 + i * 70}" font-family="Arial, sans-serif" font-weight="700" font-size="50" fill="#F7F5FA">${escape(line)}</text>`,
    )
    .join('');
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="${h}">
  <defs>
    <radialGradient id="g" cx="0.75" cy="0.25" r="1">
      <stop offset="0" stop-color="${f.from}"/>
      <stop offset="1" stop-color="${f.to}"/>
    </radialGradient>
  </defs>
  <rect width="${w}" height="${h}" fill="url(#g)"/>
  <circle cx="900" cy="230" r="300" fill="${f.accent}" opacity="0.18"/>
  <circle cx="980" cy="1150" r="420" fill="#000000" opacity="0.18"/>
  ${kente(60, w)}
  <text x="80" y="250" font-family="Arial, sans-serif" font-weight="700" font-size="44" fill="${f.accent}" letter-spacing="6">${escape(f.kicker)}</text>
  ${title}
  <rect x="80" y="860" width="140" height="10" fill="${f.accent}"/>
  ${lines}
  ${kente(h - 78, w)}
</svg>`;
}

/** Ndop-style geometric cloth, as a fashion designer would show a fabric. */
function ndop(): string {
  const size = 1080;
  const cell = 120;
  const shapes: string[] = [];
  for (let row = 0; row < size / cell; row += 1) {
    for (let col = 0; col < size / cell; col += 1) {
      const x = col * cell;
      const y = row * cell;
      const kind = (row * 3 + col) % 4;
      if (kind === 0) {
        shapes.push(
          `<polygon points="${x + 60},${y + 10} ${x + 110},${y + 60} ${x + 60},${y + 110} ${x + 10},${y + 60}" fill="#F2EADB"/>`,
        );
      } else if (kind === 1) {
        shapes.push(
          `<rect x="${x + 25}" y="${y + 25}" width="70" height="70" fill="none" stroke="#F2EADB" stroke-width="12"/>`,
        );
      } else if (kind === 2) {
        shapes.push(`<circle cx="${x + 60}" cy="${y + 60}" r="34" fill="#F2EADB"/>`);
      } else {
        shapes.push(
          `<path d="M${x + 10} ${y + 30} L${x + 110} ${y + 30} M${x + 10} ${y + 60} L${x + 110} ${y + 60} M${x + 10} ${y + 90} L${x + 110} ${y + 90}" stroke="#F2EADB" stroke-width="10"/>`,
        );
      }
    }
  }
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}">
  <rect width="${size}" height="${size}" fill="#1F2A6B"/>
  ${shapes.join('')}
</svg>`;
}

/** Sunset over the sea at Kribi, for the photographer's moodboard. */
function sunset(): string {
  const w = 1350;
  const h = 1080;
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="${h}">
  <defs>
    <linearGradient id="sky" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="#2B1055"/>
      <stop offset="0.45" stop-color="#C2410C"/>
      <stop offset="0.62" stop-color="#F5B700"/>
    </linearGradient>
    <linearGradient id="sea" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="#7A3E1D"/>
      <stop offset="1" stop-color="#0E0B14"/>
    </linearGradient>
  </defs>
  <rect width="${w}" height="${h}" fill="url(#sky)"/>
  <circle cx="680" cy="640" r="130" fill="#FFD27A"/>
  <rect y="650" width="${w}" height="${h - 650}" fill="url(#sea)"/>
  ${Array.from({ length: 9 }, (_, i) => `<rect x="${560 - i * 12}" y="${670 + i * 28}" width="${240 + i * 24}" height="6" fill="#FFD27A" opacity="${0.7 - i * 0.07}"/>`).join('')}
  <path d="M0 700 Q 200 640 360 690 T 700 700 L 700 1080 L 0 1080 Z" fill="#0E0B14" opacity="0.55"/>
  <path d="M120 560 q 10 -160 30 -260 M150 300 q -90 20 -150 70 M150 300 q 80 -10 150 40 M150 300 q -40 -60 -110 -80 M150 300 q 50 -70 120 -70" stroke="#0E0B14" stroke-width="16" fill="none"/>
</svg>`;
}

interface DemoPost {
  author: string;
  body: string | null;
  images?: string[];
  hoursAgo: number;
  likedBy: string[];
  comments: { author: string; body: string }[];
}

export async function seedDemoPosts(
  db: Db,
  ids: ReadonlyMap<string, string>,
  mediaDir: string,
): Promise<number> {
  const awa = ids.get('awa_danse');
  if (!awa) return 0;
  const [existing] = await db
    .select({ id: posts.id })
    .from(posts)
    .where(eq(posts.authorId, awa))
    .limit(1);
  if (existing) return 0;

  const root = resolve(mediaDir);
  async function image(svg: string, owner: string): Promise<string> {
    const { data, info } = await sharp(Buffer.from(svg))
      .jpeg({ quality: 85, mozjpeg: true })
      .toBuffer({ resolveWithObject: true });
    const id = uuidv7();
    const storageKey = `images/${id}.jpg`;
    const path = join(root, storageKey);
    await mkdir(dirname(path), { recursive: true });
    await writeFile(path, data);
    await db.insert(media).values({
      id,
      ownerId: owner,
      kind: 'image',
      mimeType: 'image/jpeg',
      storageKey,
      bytes: data.length,
      width: info.width,
      height: info.height,
    });
    return id;
  }

  const art: Record<string, () => string> = {
    bikutsi: () =>
      flyer({
        kicker: 'AKWA · DOUALA',
        title: ['SOIRÉE', 'BIKUTSI'],
        lines: [
          'Samedi 22 novembre · 20h',
          'Live: Awa Ngono & la troupe Mvog',
          'Entrée 2 000 FCFA',
        ],
        from: '#7A2E9E',
        to: '#1A0F2A',
        accent: '#F5B700',
      }),
    comedy: () =>
      flyer({
        kicker: 'YAOUNDÉ · BASTOS',
        title: ['STAND-UP', 'NIGHT'],
        lines: [
          'Vendredi 28 novembre · 19h30',
          'Tchoko + 4 humoristes',
          'Rires garantis, sinon on rembourse',
        ],
        from: '#C2410C',
        to: '#2A0F0A',
        accent: '#FFFFFF',
      }),
    beach: () =>
      flyer({
        kicker: 'KRIBI · PLAGE DE LOBÉ',
        title: ['BEACH', 'PARTY'],
        lines: [
          '31 décembre · du coucher du soleil à l’aube',
          'DJ Kribi · Makossa, coupé-décalé, afro',
          'Pré-vente 5 000 FCFA',
        ],
        from: '#0F766E',
        to: '#0B1B2A',
        accent: '#F5B700',
      }),
    ndop,
    sunset,
  };

  const demo: DemoPost[] = [
    {
      author: 'dj_kribi',
      body: 'On remet ça pour le 31 ! Qui descend à Kribi ? 🌊 #KribiBeach #makossa',
      images: ['beach'],
      hoursAgo: 2,
      likedBy: ['awa_danse', 'tchoko_comedy', 'nkeng_sings', 'eric_lens'],
      comments: [
        { author: 'awa_danse', body: 'On sera là avec la troupe !' },
        { author: 'eric_lens', body: 'Je prends les photos, réserve-moi une place devant 📸' },
      ],
    },
    {
      author: 'awa_danse',
      body: 'Dernière répétition avant samedi. Venez nombreux, on a préparé un tableau spécial pour les 10 ans de la troupe. #bikutsi #Douala',
      images: ['bikutsi'],
      hoursAgo: 5,
      likedBy: ['nkeng_sings', 'dj_kribi', 'manka_acts', 'brice_events', 'fanta_couture'],
      comments: [
        { author: 'nkeng_sings', body: 'Je viens chanter avec vous ? 😄' },
        { author: 'awa_danse', body: '@nkeng_sings toujours ! Passe aux répétitions jeudi.' },
        {
          author: 'brice_events',
          body: 'Bravo pour les 10 ans. Je vous contacte pour un mariage en janvier.',
        },
      ],
    },
    {
      author: 'brice_events',
      body: 'Organisateurs : arrêtez de chercher vos artistes dans 15 groupes WhatsApp. J’ai trouvé une chanteuse et un MC pour samedi en une matinée ici. Postez vos appels, ça marche.',
      hoursAgo: 9,
      likedBy: ['nkeng_sings', 'awa_danse', 'tchoko_comedy'],
      comments: [{ author: 'tchoko_comedy', body: 'Et les humoristes aussi on est là hein 😅' }],
    },
    {
      author: 'fanta_couture',
      body: 'Nouvelle collection inspirée du ndop de l’Ouest. Pièces uniques, sur mesure. Commandes ouvertes jusqu’au 15 décembre.',
      images: ['ndop'],
      hoursAgo: 20,
      likedBy: ['awa_danse', 'manka_acts', 'nkeng_sings'],
      comments: [
        { author: 'manka_acts', body: 'Il me faut ça pour le tournage du mois prochain !' },
      ],
    },
    {
      author: 'tchoko_comedy',
      body: 'Vendredi on fait salle comble ou rien. 4 humoristes, 0 temps mort. Les billets partent vite.',
      images: ['comedy'],
      hoursAgo: 30,
      likedBy: ['dj_kribi', 'brice_events'],
      comments: [],
    },
    {
      author: 'eric_lens',
      body: 'Coucher de soleil à Kribi, pour mon moodboard de shooting mariage plage. Les couples, écrivez-moi pour 2027.',
      images: ['sunset'],
      hoursAgo: 46,
      likedBy: ['dj_kribi', 'fanta_couture', 'awa_danse', 'nkeng_sings'],
      comments: [{ author: 'dj_kribi', body: 'Ces couleurs 🔥' }],
    },
    {
      author: 'manka_acts',
      body: 'Casting réussi pour la série de Canal 2 ! Merci à tous ceux qui m’ont aidée à préparer le monologue. Prochaine étape : les essais caméra.',
      hoursAgo: 70,
      likedBy: ['awa_danse', 'fanta_couture', 'nkeng_sings', 'tchoko_comedy', 'eric_lens'],
      comments: [{ author: 'fanta_couture', body: 'Félicitations ma sœur 👏🏾' }],
    },
    {
      author: 'nkeng_sings',
      body: 'Merci Bonapriso pour samedi soir. Quatre heures de makossa et personne ne s’est assis. Prochaine date bientôt.',
      hoursAgo: 96,
      likedBy: ['awa_danse', 'dj_kribi', 'brice_events'],
      comments: [{ author: 'brice_events', body: 'Quelle voix. On se reparle pour janvier.' }],
    },
  ];

  const now = Date.now();
  for (const item of demo) {
    const authorId = ids.get(item.author);
    if (!authorId) continue;
    const mediaIds: string[] = [];
    for (const name of item.images ?? []) {
      const draw = art[name];
      if (draw) mediaIds.push(await image(draw(), authorId));
    }
    const createdAt = new Date(now - item.hoursAgo * HOUR);
    const postId = uuidv7(createdAt.getTime());
    const likers = item.likedBy.flatMap((u) => {
      const id = ids.get(u);
      return id && id !== authorId ? [id] : [];
    });
    await db.insert(posts).values({
      id: postId,
      authorId,
      kind: mediaIds.length > 0 ? 'photo' : 'text',
      body: item.body,
      likesCount: likers.length,
      commentsCount: item.comments.length,
      sharesCount: Math.floor(likers.length / 2),
      createdAt,
    });
    if (mediaIds.length > 0) {
      await db
        .insert(postMedia)
        .values(mediaIds.map((mediaId, position) => ({ postId, mediaId, position })));
    }
    if (likers.length > 0) {
      await db.insert(postLikes).values(likers.map((userId) => ({ postId, userId })));
      await db.insert(notifications).values(
        likers.slice(0, 2).map((actorId) => ({
          userId: authorId,
          type: 'post_liked' as const,
          actorId,
          postId,
        })),
      );
    }
    for (const [index, comment] of item.comments.entries()) {
      const commenter = ids.get(comment.author);
      if (!commenter) continue;
      const at = new Date(createdAt.getTime() + (index + 1) * 20 * 60_000);
      const commentId = uuidv7(at.getTime());
      await db.insert(comments).values({
        id: commentId,
        postId,
        authorId: commenter,
        body: comment.body,
        createdAt: at,
      });
      if (commenter !== authorId) {
        await db.insert(notifications).values({
          userId: authorId,
          type: 'post_commented',
          actorId: commenter,
          postId,
          commentId,
        });
      }
    }
  }
  // Keep counters honest if a commenter was missing.
  await db.execute(
    sql`update posts set comments_count = (select count(*) from comments c where c.post_id = posts.id)`,
  );
  return demo.length;
}
