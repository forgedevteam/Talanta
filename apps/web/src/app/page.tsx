import { TALENTS } from '@/lib/talents';

export default function HomePage() {
  return (
    <main className="mx-auto flex min-h-dvh max-w-5xl flex-col px-6 py-10 sm:px-10">
      <header className="flex items-center justify-between">
        <span className="wordmark font-display text-2xl font-semibold tracking-tight">Talanta</span>
        <a
          href="#waitlist"
          className="rounded-sm border border-outline px-4 py-2 text-sm font-semibold text-text transition-colors hover:border-primary"
        >
          Get early access
        </a>
      </header>

      <section className="mt-24 grid gap-12 md:mt-32 md:grid-cols-[3fr_2fr] md:items-end">
        <div>
          <p className="text-sm font-semibold uppercase tracking-[0.2em] text-gold">Launching in Nigeria, Kenya, Ghana and South Africa</p>
          <h1 className="font-display mt-5 text-5xl font-semibold leading-[1.02] tracking-tight text-text sm:text-7xl">
            Where Africa&rsquo;s talent lives.
          </h1>
          <p className="mt-6 max-w-xl text-lg leading-relaxed text-text-muted">
            Short videos, monthly challenges and real opportunities for singers, dancers, actors,
            comedians, makers and the people who love what they do.
          </p>
          <div id="waitlist" className="mt-10 flex flex-col gap-3 sm:flex-row">
            <a
              href="mailto:hello@talanta.app?subject=Early%20access"
              className="rounded-sm bg-primary px-6 py-4 text-center text-base font-semibold text-on-primary transition-transform hover:-translate-y-0.5"
            >
              Join the early list
            </a>
            <a
              href="#talents"
              className="rounded-sm border border-outline px-6 py-4 text-center text-base font-semibold text-text transition-colors hover:border-primary"
            >
              See the talents
            </a>
          </div>
        </div>

        <aside className="rounded-lg border border-outline bg-surface p-6">
          <p className="text-sm font-semibold text-text-muted">How it works</p>
          <ol className="mt-4 space-y-4 text-text">
            <li className="flex gap-3">
              <span className="font-display text-xl font-semibold text-primary">1</span>
              <span>Sign in with your phone number. No password.</span>
            </li>
            <li className="flex gap-3">
              <span className="font-display text-xl font-semibold text-primary">2</span>
              <span>Pick your talents and the city you create from.</span>
            </li>
            <li className="flex gap-3">
              <span className="font-display text-xl font-semibold text-primary">3</span>
              <span>Post, join challenges and get discovered.</span>
            </li>
          </ol>
        </aside>
      </section>

      <section id="talents" className="mt-24">
        <h2 className="font-display text-2xl font-semibold text-text">Made for every kind of talent</h2>
        <ul className="mt-6 flex flex-wrap gap-2">
          {TALENTS.map((talent) => (
            <li
              key={talent}
              className="rounded-pill border border-outline bg-surface px-4 py-2 text-sm font-semibold text-text"
            >
              {talent}
            </li>
          ))}
        </ul>
      </section>

      <footer className="mt-auto pt-24 text-sm text-text-muted">
        <p>Talanta is being built in the open with creators across the continent.</p>
      </footer>
    </main>
  );
}
