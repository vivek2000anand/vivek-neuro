# Project Structure

- `vivek_neuro/`: Root directory of the Zola site
    - `content/`: Markdown and Typst content
        - `blog/`: Blog posts
            - `stop-guessing-perceptual-dimensionality-an-occams-razor-for-ordinal-embeddings/`: LORE blog post
            - `from-scales-to-spaces-episode-1-building-the-psychological-ruler/`: Blog post series episode 1
            - `from-scales-to-spaces-episode-2-from-ruler-to-map/`: Blog post series episode 2
            - `vibecoding-this-website-with-antigravity/`: Antigravity workflow post
    - `build.ps1`: Build script to convert Typst to HTML via Pandoc
    - `templates/`: Zola HTML templates
    - `static/`: Static assets
        - `files/`
            - `csl/`: Citation Style Language files (e.g. `ieee.csl`)
    - `sass/`: SCSS styles

## Key Files
- `build.ps1`: Orchestrates the Typst -> HTML conversion.
