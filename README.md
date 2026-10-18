# media

Placeholder (FPO) images, videos and SVGs for CodePen and HTML prototypes, served from GitHub Pages so every file has a stable public URL.

- **Gallery:** https://vanturk.github.io/media/ (click any file to copy its URL, an HTML tag, a CSS background or, for SVGs, the markup itself)
- **File list:** https://vanturk.github.io/media/manifest.json
- **Starter stylesheet:** https://vanturk.github.io/media/reset.css

## What's in here

```
media/
├── dessert/          cinema · landscape · portrait · square   (0–17.webp each)
├── fruit/            cinema · landscape · portrait · square   (0–17.webp each)
├── interior-design/  cinema · landscape · portrait · square   (0–13.webp each)
├── oversize/         cinema · landscape · portrait · square   (0–13.webp each)
├── male/             landscape · portrait · square            (0–10.webp each)
├── female/           landscape · portrait · square            (0–10.webp each)
├── baking/           cinema · landscape · portrait · square   (1–13.webp each)
├── bread/            cinema · landscape · portrait · square   (1–14.webp each)
├── buildings/        cinema · landscape · portrait · square   (1–17.webp each)
├── friends/          cinema · landscape · portrait · square   (1–8.webp each)
├── pasta/            cinema · landscape · portrait · square   (1–12.webp each)
├── veggies/          cinema · landscape · portrait · square   (1–28.webp each)
├── pokemon/          square                                   (1–24.webp)
├── vids/             landscape · portrait · square            (vid-1 … vid-10.mp4 each)
├── svg/              arrows/set-1 … set-5 (8 each) · shapes/ · vector/ · 2 loose files
│   ├── shapes/       abstract (37) · geometric (29) · line (11) · starburst (32)
│   └── vector/       fish (15) · flowers (12) · insects (24) · leaf (18)
├── reset.css
└── manifest.json
```

| Shape | Images | Videos |
|---|---|---|
| cinema | 2000×960 (baking, bread, buildings, friends, pasta, veggies: 1200×576) | |
| landscape | 2000×1350 (male, female: 800×540; baking, bread, buildings, friends, pasta: 1200×800; veggies: 1200×900) | 1280×720 |
| portrait | 800×1080 (baking, bread, buildings, friends: 800×1200; veggies: 900×1200) | 720×1280 |
| square | 800×800 (baking, bread, buildings, friends, pasta, veggies: 1000×1000; pokemon: 475×475) | 720×720 |

- **Images:** WebP, quality 80. In the folders numbered from 0, `0.webp` is a grey placeholder graphic; baking, bread, buildings, friends, pasta and veggies start at `1.webp`. Pokémon images have transparent backgrounds. A few images are off their shape's usual size (cinema 2025×960 and 2000×959, three baking landscapes at 1200×801, one friends square at 1500×1500); `manifest.json` has the exact size of every file.
- **Smaller cinema crops:** the cinema images in baking, bread, buildings, friends, pasta and veggies are center crops of their landscape images, kept at 1200 wide rather than enlarged to 2000. They have the same proportions as the other cinema images.
- **SVGs:** 220 files, kept in their own folders rather than split into shapes, so each file is its native size (`manifest.json` lists them). Shapes and vectors are numbered `1.svg`, `2.svg` and so on, with no leading zeros. Arrows are named by direction, including the spellings `set-3/bototm-left.svg` and `set-5/bottom-rigth.svg`. Insects jump from `10.svg` to `21.svg`. Most are dark `#181818` line work on a transparent background. They've been run through SVGO (coordinates rounded to two decimal places; `viewBox`, sizes and IDs kept).
- **Videos:** MP4 (H.264), each under 3 MB, set to start playing before the whole file downloads. The same `vid-N` is the same clip in all three shapes. Clips 3, 6 and 8 have no sound; the rest do.
- **Total size:** about 115 MB.

## URLs

```
https://vanturk.github.io/media/<category>/<shape>/<n>.webp
https://vanturk.github.io/media/vids/<shape>/vid-<n>.mp4
https://vanturk.github.io/media/svg/<folder>/<name>.svg
```

**Image**

```html
<img src="https://vanturk.github.io/media/interior-design/landscape/3.webp"
     alt="" width="2000" height="1350" style="width:100%;height:auto">
```

**Background video** (browsers only autoplay muted video)

```html
<video autoplay muted loop playsinline
       src="https://vanturk.github.io/media/vids/portrait/vid-6.mp4"></video>
```

**SVG** (to restyle strokes and fills with CSS, use the gallery's "Inline SVG" copy option instead)

```html
<img src="https://vanturk.github.io/media/svg/shapes/starburst/1.svg"
     alt="" width="300" height="300">
```

**Starter stylesheet**

```html
<link rel="stylesheet" href="https://vanturk.github.io/media/reset.css">
```

**CSS background**

```css
.hero { background: url("https://vanturk.github.io/media/oversize/cinema/2.webp") center / cover; }
```

**A random image from the manifest**

```js
const m = await (await fetch("https://vanturk.github.io/media/manifest.json")).json();
const pick = list => list[Math.floor(Math.random() * list.length)];
const img = pick(m.images.fruit.square);
document.querySelector("img").src = m.base + img.src;
// SVGs are grouped by folder: m.svgs["svg/shapes/starburst"], m.svgs["svg/arrows/set-1"], …
```

All of these work as they are in CodePen, JSFiddle or a local HTML file.

## Adding or changing files

1. Settle file sizes **before** committing. Git keeps every version of every file, so replacing a file later still leaves the old copy in the repo's size.
2. Image folders follow `<category>/<shape>/<n>.webp`, with shape one of `cinema`, `landscape`, `portrait` or `square`. A new category folder shows up in the gallery automatically once the manifest is rebuilt.
3. Keep videos under 3 MB and in the same `vid-N` numbering across all three shapes.
4. SVGs go anywhere under `svg/`, with any folder depth or file name (number them without leading zeros). Optimize them before committing:
   ```bash
   npx svgo@4 --config scripts/svgo.config.mjs -rf svg
   ```
5. Rebuild the file list (needs `ffprobe`, from `brew install ffmpeg`):
   ```bash
   bash scripts/build-manifest.sh
   ```
6. Commit and push. Pages updates within a minute or two.

Use plain Git, not Git LFS. GitHub Pages doesn't serve LFS files.

## Search engines

The gallery page carries a `noindex` tag. Images and videos are blocked from crawlers by https://vanturk.github.io/robots.txt, which lives in the separate [`vanturk.github.io`](https://github.com/vanturk/vanturk.github.io) repo. This keeps the files out of search results but doesn't make them private: anyone with a URL can open them, and this repo is public.

## Limits

| | Limit |
|---|---|
| Single file | Blocked over 100 MiB; warning over 50 MiB |
| Published Pages site | 1 GB maximum |
| Pages bandwidth | 100 GB/month (soft limit) |

Checked October 2026. See [GitHub Pages limits](https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits).

## What not to use

- **raw.githubusercontent.com links.** They aren't a CDN, can be rate-limited, and some file types come back with the wrong content type.
- **jsDelivr for the videos.** Its [terms](https://raw.githubusercontent.com/jsdelivr/jsdelivr/master/Terms%20of%20Use.md) rule out general media hosting.
