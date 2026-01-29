# Project Structure

- `vivek_neuro/`: Root directory of the Zola site
    - `content/`: Markdown and Typst content
        - `blog/`: Blog posts
    - `build.ps1`: Build script to convert Typst to HTML via Pandoc
    - `templates/`: Zola HTML templates
    - `static/`: Static assets
        - `files/`
            - `csl/`: Citation Style Language files (e.g. `ieee.csl`)
    - `sass/`: SCSS styles

## Key Files
- `build.ps1`: Orchestrates the Typst -> HTML conversion.
