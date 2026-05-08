# Reveal.js slides (Pandoc)

Prerequisites:

- `pandoc` installed (with support for reveal.js) — install via Homebrew or from pandoc website.
- A working internet connection (the build script uses the reveal.js CDN). To bundle reveal.js locally, download reveal.js and adjust the pandoc `-V revealjs-url` flag.

Build:

```sh
./build_slides.sh
```

This will produce `slides.html` in the repository root. Open it in a browser.

Notes:

- The build includes `custom.css` for modern styling.
- Current image files used by slides: `single_cycle_processor_image.jpeg` and `demo_output.png`.
- You can further customize reveal variables in `build_slides.sh` (theme, transition, size, etc.).
