import { eq } from 'drizzle-orm';
import sharp from 'sharp';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';

import { users } from '../src/database/schema/index.js';
import { bearer, createTestApp, onboard, type Member, type TestApp } from './support/test-app.js';

/** A real JPEG carrying GPS metadata, like a phone photo. */
async function photo(width = 1200, height = 900): Promise<Buffer> {
  return sharp({
    create: { width, height, channels: 3, background: { r: 200, g: 90, b: 40 } },
  })
    .jpeg()
    .withExif({
      IFD0: { Make: 'TestPhone' },
      IFD3: { GPSLatitudeRef: 'N', GPSLatitude: '4/1 3/1 0/1' },
    })
    .toBuffer();
}

/** The first bytes of an MP4 file; enough for the type check. */
function video(): Buffer {
  const header = Buffer.alloc(64);
  header.writeUInt32BE(32, 0);
  header.write('ftypisom', 4, 'latin1');
  header.write('isomiso2avc1mp41', 16, 'latin1');
  return header;
}

interface Uploaded {
  id: string;
  kind: string;
  url: string;
  width: number | null;
  height: number | null;
}

interface PostBody {
  id: string;
  kind: string;
  body: string | null;
  media: Uploaded[];
  isReel: boolean;
  likeCount: number;
  commentCount: number;
  shareCount: number;
  likedByMe: boolean;
  isMine: boolean;
  author: { username: string; avatarUrl: string | null };
}

describe('photos, videos and posts', () => {
  let app: TestApp;
  let nkeng: Member;
  let awa: Member;
  let stranger: Member;

  beforeAll(async () => {
    app = await createTestApp();
    nkeng = await onboard(app, { talent: 'music' });
    awa = await onboard(app, { talent: 'dance' });
    stranger = await onboard(app, { talent: 'comedy' });
  });

  afterAll(async () => {
    await app.close();
  });

  function upload(who: Member, data: Buffer, purpose?: string) {
    return app.http
      .post(`/v1/media${purpose ? `?purpose=${purpose}` : ''}`)
      .set(...bearer(who))
      .attach('file', data, 'upload.bin');
  }

  async function uploaded(who: Member, data: Buffer, purpose?: string): Promise<Uploaded> {
    return (await upload(who, data, purpose).expect(201)).body as Uploaded;
  }

  async function post(who: Member, body: object): Promise<PostBody> {
    return (
      await app.http
        .post('/v1/posts')
        .set(...bearer(who))
        .send(body)
        .expect(201)
    ).body as PostBody;
  }

  describe('uploads', () => {
    it('re-encodes photos, keeps them under 1600 px and strips location data', async () => {
      const file = await uploaded(nkeng, await photo(3000, 2000));
      expect(file).toMatchObject({ kind: 'image', width: 1600, height: 1067 });
      expect(file.url).toMatch(/^\/media\/images\/[0-9a-f-]{36}\.jpg$/);

      const served = await app.http.get(file.url).buffer(true).expect(200);
      expect(served.headers['content-type']).toBe('image/jpeg');
      expect(served.headers['x-content-type-options']).toBe('nosniff');
      const metadata = await sharp(served.body as Buffer).metadata();
      expect(metadata.exif).toBeUndefined();
    });

    it('crops profile pictures square', async () => {
      const file = await uploaded(nkeng, await photo(1200, 800), 'avatar');
      expect(file).toMatchObject({ width: 640, height: 640 });
    });

    it('accepts an MP4 video', async () => {
      const file = await uploaded(nkeng, video());
      expect(file.kind).toBe('video');
      expect(file.url).toMatch(/\.mp4$/);
    });

    it.each([
      ['a web page', Buffer.from('<html><script>alert(1)</script></html>'.padEnd(64, ' '))],
      ['a script', Buffer.from('#!/bin/sh\nrm -rf /\n'.padEnd(64, ' '))],
      ['a truncated photo', Buffer.from([0xff, 0xd8, 0xff, 0xe0, ...Array<number>(60).fill(0)])],
    ])('refuses %s whatever it is called', async (_label, data) => {
      const response = await upload(nkeng, data).expect(415);
      expect(response.body).toMatchObject({ code: 'media_unsupported' });
    });

    it('refuses a video as a profile picture', async () => {
      await upload(nkeng, video(), 'avatar').expect(415);
    });

    it('needs a signed-in member', async () => {
      await app.http
        .post('/v1/media')
        .attach('file', await photo(), 'a.jpg')
        .expect(401);
    });

    it('cannot reach files outside the media folder', async () => {
      for (const path of ['/media/../package.json', '/media/%2e%2e/package.json']) {
        const response = await app.http.get(path);
        expect([403, 404]).toContain(response.status);
        expect(response.text).not.toContain('@talanta/api');
      }
    });
  });

  describe('profile picture and bio', () => {
    it('sets a picture from an upload and shows it on cards', async () => {
      const file = await uploaded(nkeng, await photo(), 'avatar');
      const me = await app.http
        .put('/v1/me/avatar')
        .set(...bearer(nkeng))
        .send({ mediaId: file.id })
        .expect(200);
      expect((me.body as { profile: { avatarUrl: string } }).profile.avatarUrl).toBe(file.url);

      const created = await post(nkeng, { body: 'Hello Douala' });
      expect(created.author.avatarUrl).toBe(file.url);
    });

    it('will not use someone else’s upload', async () => {
      const file = await uploaded(awa, await photo(), 'avatar');
      await app.http
        .put('/v1/me/avatar')
        .set(...bearer(nkeng))
        .send({ mediaId: file.id })
        .expect(404);
    });

    it('removes the picture', async () => {
      const me = await app.http
        .delete('/v1/me/avatar')
        .set(...bearer(nkeng))
        .expect(200);
      expect((me.body as { profile: { avatarUrl: string | null } }).profile.avatarUrl).toBeNull();
    });

    it('keeps the bio when a save leaves it out, and clears it when sent empty', async () => {
      const profile = { displayName: 'Nkeng Ebai', username: nkeng.username, city: 'Douala' };
      await app.http
        .put('/v1/me/profile')
        .set(...bearer(nkeng))
        .send({ ...profile, bio: 'Makossa and soul.' })
        .expect(200);
      const kept = await app.http
        .put('/v1/me/profile')
        .set(...bearer(nkeng))
        .send(profile);
      expect((kept.body as { profile: { bio: string } }).profile.bio).toBe('Makossa and soul.');

      const cleared = await app.http
        .put('/v1/me/profile')
        .set(...bearer(nkeng))
        .send({ ...profile, bio: '' });
      expect((cleared.body as { profile: { bio: string | null } }).profile.bio).toBeNull();
    });
  });

  describe('posting', () => {
    it('shares words, keeping line breaks', async () => {
      const created = await post(nkeng, { body: '  Rehearsal tonight.\n\n\n\nWho is coming?  ' });
      expect(created).toMatchObject({
        kind: 'text',
        body: 'Rehearsal tonight.\n\nWho is coming?',
        isMine: true,
        likeCount: 0,
      });
    });

    it('shares photos in the order given', async () => {
      const first = await uploaded(nkeng, await photo());
      const second = await uploaded(nkeng, await photo());
      const created = await post(nkeng, { body: 'Bonapriso', mediaIds: [second.id, first.id] });
      expect(created.kind).toBe('photo');
      expect(created.media.map((file) => file.id)).toEqual([second.id, first.id]);
    });

    it('shares a video as a reel', async () => {
      const clip = await uploaded(awa, video());
      const created = await post(awa, { mediaIds: [clip.id], isReel: true });
      expect(created).toMatchObject({ kind: 'video', isReel: true, body: null });
    });

    it.each([
      ['nothing at all', async () => ({})],
      [
        'a video with photos',
        async () => ({
          mediaIds: [
            (await uploaded(nkeng, video())).id,
            (await uploaded(nkeng, await photo())).id,
          ],
        }),
      ],
      [
        'a photo as a reel',
        async () => ({
          mediaIds: [(await uploaded(nkeng, await photo())).id],
          isReel: true,
        }),
      ],
      [
        'someone else’s file',
        async () => ({
          mediaIds: [(await uploaded(awa, await photo())).id],
        }),
      ],
    ])('refuses %s', async (_label, build) => {
      await app.http
        .post('/v1/posts')
        .set(...bearer(nkeng))
        .send(await build())
        .expect(422);
    });

    it('will not put one file in two posts', async () => {
      const file = await uploaded(nkeng, await photo());
      await post(nkeng, { mediaIds: [file.id] });
      await app.http
        .post('/v1/posts')
        .set(...bearer(nkeng))
        .send({ mediaIds: [file.id] })
        .expect(422);
    });
  });

  describe('feeds', () => {
    it('shows everyone in For you, and only people I follow in Following', async () => {
      const own = await post(stranger, { body: 'Stand-up at Akwa on Friday' });
      const forYou = (
        await app.http
          .get('/v1/feed')
          .set(...bearer(stranger))
          .expect(200)
      ).body as { items: PostBody[] };
      expect(forYou.items.some((item) => item.author.username === nkeng.username)).toBe(true);

      await app.http.post(`/v1/creators/${awa.username}/follow`).set(...bearer(stranger));
      const following = (
        await app.http
          .get('/v1/feed?tab=following')
          .set(...bearer(stranger))
          .expect(200)
      ).body as { items: PostBody[] };
      const authors = new Set(following.items.map((item) => item.author.username));
      expect(authors).toEqual(new Set([awa.username, stranger.username]));
      expect(following.items.some((item) => item.id === own.id)).toBe(true);
    });

    it('lists only videos marked as reels in Reels', async () => {
      const reels = (
        await app.http
          .get('/v1/reels')
          .set(...bearer(nkeng))
          .expect(200)
      ).body as {
        items: PostBody[];
      };
      expect(reels.items.length).toBeGreaterThan(0);
      expect(reels.items.every((item) => item.isReel && item.kind === 'video')).toBe(true);
    });

    it('pages without repeating posts', async () => {
      const first = (
        await app.http
          .get('/v1/feed?limit=2')
          .set(...bearer(nkeng))
          .expect(200)
      ).body as { items: PostBody[]; nextCursor: string };
      const second = (
        await app.http
          .get(`/v1/feed?limit=2&cursor=${first.nextCursor}`)
          .set(...bearer(nkeng))
          .expect(200)
      ).body as { items: PostBody[] };
      const ids = [...first.items, ...second.items].map((item) => item.id);
      expect(new Set(ids).size).toBe(ids.length);
    });

    it('shows a creator’s posts and counts them on their profile', async () => {
      const profile = (
        await app.http
          .get(`/v1/creators/${nkeng.username}`)
          .set(...bearer(awa))
          .expect(200)
      ).body as { postCount: number };
      const page = (
        await app.http
          .get(`/v1/creators/${nkeng.username}/posts`)
          .set(...bearer(awa))
          .expect(200)
      ).body as { items: PostBody[] };
      expect(profile.postCount).toBe(page.items.length);
      expect(page.items.every((item) => item.author.username === nkeng.username)).toBe(true);
    });
  });

  describe('likes, comments and shares', () => {
    let target: PostBody;

    beforeAll(async () => {
      target = await post(nkeng, { body: 'New song for my mama. One take.' });
    });

    it('counts a like once, and takes it back', async () => {
      const like = () => app.http.post(`/v1/posts/${target.id}/like`).set(...bearer(awa));
      expect((await like().expect(200)).body).toEqual({ liked: true, likeCount: 1 });
      expect((await like().expect(200)).body).toEqual({ liked: true, likeCount: 1 });

      const unliked = await app.http
        .delete(`/v1/posts/${target.id}/like`)
        .set(...bearer(awa))
        .expect(200);
      expect(unliked.body).toEqual({ liked: false, likeCount: 0 });
      await like().expect(200);

      const seen = (await app.http.get(`/v1/posts/${target.id}`).set(...bearer(awa)))
        .body as PostBody;
      expect(seen).toMatchObject({ likedByMe: true, likeCount: 1, isMine: false });
    });

    it('tells the author once, however often someone likes and unlikes', async () => {
      const notices = (
        await app.http
          .get('/v1/me/notifications')
          .set(...bearer(nkeng))
          .expect(200)
      ).body as { items: { type: string; postId: string; snippet: string }[] };
      const likes = notices.items.filter(
        (item) => item.type === 'post_liked' && item.postId === target.id,
      );
      expect(likes).toHaveLength(1);
      expect(likes[0]?.snippet).toBe('New song for my mama. One take.');
    });

    it('adds comments in order and tells the author', async () => {
      for (const body of ['Your voice!', 'Collab on part 2?']) {
        await app.http
          .post(`/v1/posts/${target.id}/comments`)
          .set(...bearer(awa))
          .send({ body })
          .expect(201);
      }
      const page = (
        await app.http
          .get(`/v1/posts/${target.id}/comments`)
          .set(...bearer(nkeng))
          .expect(200)
      ).body as { items: { id: string; body: string; canDelete: boolean }[] };
      expect(page.items.map((item) => item.body)).toEqual(['Your voice!', 'Collab on part 2?']);
      expect(page.items.every((item) => item.canDelete)).toBe(true);

      const notices = (await app.http.get('/v1/me/notifications').set(...bearer(nkeng))).body as {
        items: { type: string; snippet: string }[];
      };
      expect(notices.items[0]).toMatchObject({
        type: 'post_commented',
        snippet: 'Collab on part 2?',
      });
    });

    it('lets the writer or the post owner delete a comment, and nobody else', async () => {
      const page = (await app.http.get(`/v1/posts/${target.id}/comments`).set(...bearer(stranger)))
        .body as { items: { id: string; canDelete: boolean }[] };
      const [first] = page.items;
      expect(first?.canDelete).toBe(false);
      await app.http
        .delete(`/v1/comments/${first?.id}`)
        .set(...bearer(stranger))
        .expect(404);
      await app.http
        .delete(`/v1/comments/${first?.id}`)
        .set(...bearer(nkeng))
        .expect(204);

      const seen = (await app.http.get(`/v1/posts/${target.id}`).set(...bearer(nkeng)))
        .body as PostBody;
      expect(seen.commentCount).toBe(1);
    });

    it('gives a link to share and counts each person once', async () => {
      const share = () => app.http.post(`/v1/posts/${target.id}/share`).set(...bearer(awa));
      expect((await share().expect(200)).body).toEqual({
        url: `https://talanta.app/p/${target.id}`,
        shareCount: 1,
      });
      expect((await share().expect(200)).body).toMatchObject({ shareCount: 1 });
    });

    it('accepts reports about posts and comments', async () => {
      await app.http
        .post('/v1/reports')
        .set(...bearer(stranger))
        .send({ targetType: 'post', targetId: target.id, reason: 'spam' })
        .expect(204);
    });
  });

  describe('taking posts down', () => {
    it('lets only the author delete a post, which then disappears', async () => {
      const created = await post(awa, { body: 'Short-lived' });
      await app.http
        .delete(`/v1/posts/${created.id}`)
        .set(...bearer(nkeng))
        .expect(404);
      await app.http
        .delete(`/v1/posts/${created.id}`)
        .set(...bearer(awa))
        .expect(204);
      await app.http
        .get(`/v1/posts/${created.id}`)
        .set(...bearer(awa))
        .expect(404);
    });

    it('hides everything a suspended account posted', async () => {
      const created = await post(stranger, { body: 'Buy followers cheap' });
      await app.db.update(users).set({ status: 'suspended' }).where(eq(users.id, stranger.userId));
      await app.http
        .get(`/v1/posts/${created.id}`)
        .set(...bearer(nkeng))
        .expect(404);
      const feed = (await app.http.get('/v1/feed?limit=50').set(...bearer(nkeng))).body as {
        items: PostBody[];
      };
      expect(feed.items.some((item) => item.author.username === stranger.username)).toBe(false);
      await app.db.update(users).set({ status: 'active' }).where(eq(users.id, stranger.userId));
    });

    it('deletes a closed account’s files, not just its posts', async () => {
      const leaver = await onboard(app);
      const file = await uploaded(leaver, await photo());
      await post(leaver, { mediaIds: [file.id] });
      await app.http.get(file.url).expect(200);

      await app.http
        .delete('/v1/me')
        .set(...bearer(leaver))
        .expect(204);
      await app.http.get(file.url).expect(404);
    });
  });
});
