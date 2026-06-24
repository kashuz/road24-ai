# road24-landing

**Marketing landing site** for Road24. Static-site generated with **Gatsby** (React).

- **Repo:** kashuz/road24-landing · **Stack:** Gatsby (React), `gatsby-*` config files, nginx for
  serving, Dockerized. Branch: `master`.
- **Has `.claude/`:** no.

## Layout
`gatsby-config.js` · `gatsby-node.js` · `gatsby-browser.js` · `gatsby-ssr.js` · `src/` (pages,
components, templates) · `nginx.conf` · `Dockerfile`.

## Commands
```bash
npm install
npm run develop   # gatsby develop (or `gatsby develop`)
npm run build     # gatsby build → public/
npm run serve
```
(Confirm script names in package.json.)

## Conventions
- Gatsby data layer (GraphQL) + page/templates model. Static marketing content — performance, SEO,
  and image optimization matter more than app state.
- No business logic; mostly presentational. Localize copy if multi-language.
- Use `react-engineer` for component work, but mind Gatsby-specific build/data conventions.
