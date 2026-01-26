# Vivek Anand's Research Website

A personal academic website built with [Zola](https://www.getzola.org/), featuring a blog with Typst support and publications imported from BibTeX.

## Quick Start

```powershell
# Serve locally with hot reload
zola serve

# Build for production
zola build
```

The built site will be in the `public/` directory.

---

## Project Structure

```
vivek_neuro/
├── content/
│   ├── _index.md           # Homepage content (bio, education)
│   ├── blog/               # Blog posts (each in its own folder)
│   └── publications/       # Generated from BibTeX
├── templates/              # Zola HTML templates
├── sass/                   # SCSS stylesheets
├── static/                 # Static assets (copied as-is)
│   ├── images/             # Profile photo, etc.
│   └── files/              # PDFs (posters, papers)
├── scripts/                # Utility scripts
└── publications.bib        # Your BibTeX file
```

---

## Making Changes

### Update Your Bio/About

Edit `content/_index.md`:
- Bio paragraphs are in `[[extra.bio_paragraphs]]` sections
- Education is in `[[extra.education]]` sections
- Social links are at the top of `[extra]`

### Add a Blog Post

```powershell
# Create new blog post (uses Typst)
.\scripts\new-post.ps1 -Title "Your Post Title" -Tags "tag1,tag2"
```

Or manually create `content/blog/my-post/index.md`.

### Add Citations to Blog Post

1. Create a `.bib` file in your post's directory (e.g., `refs.bib`).
2. Add BibTeX entries.
3. In your `content.typ`, link the bibliography:
   ```typst
   #bibliography("refs.bib")
   ```
4. Cite using `@key` (e.g., `@shepard1987`).
5. Run `.\build.ps1` to generate with citations.

### Add/Update Publications

1. **Edit `publications.bib`** with your entries:
   ```bibtex
   @article{yourkey2024,
     title = {Your Paper Title},
     author = {Anand, Vivek and Coauthor, Name},
     year = {2024},
     journal = {Journal Name},
     tags = {tag1, tag2},
     paper_url = {https://example.com/paper.pdf},
     poster_url = {files/your-poster.pdf},     # Local file
     slides_url = {files/your-slides.pdf},     # Local file
     code_url = {https://github.com/you/repo},
     video_url = {https://youtube.com/...},
     website_url = {https://project-site.com},
     blog_url = {/blog/your-summary-post/},
     award = {Best Paper Award}                 # Optional
   }
   ```

2. **Run the parser**:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\bib-to-zola.ps1 -BibFile publications.bib
   ```

3. **Add local PDFs** to `static/files/` (e.g., posters, slides)

### Supported BibTeX Fields

| Field | Description |
|-------|-------------|
| `title`, `author`, `year` | Required |
| `journal` / `booktitle` | Venue name |
| `tags` | Comma-separated, become site-wide tags |
| `paper_url` | Link to PDF (external URL or `files/...`) |
| `poster_url` | Poster PDF |
| `slides_url` | Presentation slides |
| `video_url` | Video recording |
| `code_url` | Code repository |
| `website_url` | Project website |
| `blog_url` | Related blog post |
| `award` | Award text (displays as green badge) |
| `doi` | DOI identifier |
| `abstract` | Shows on publication detail page |

---

## Styling

- **SCSS files** are in `sass/`
- Main variables: `sass/_variables.scss`
- Components: `sass/_components.scss`
- Dark/light mode is automatic (uses CSS variables)

---

## Deployment (Netlify + GitHub)

### Step 1: Push to GitHub

```powershell
# Initialize git (if not already)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit"

# Add your GitHub repo as remote
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Push
git push -u origin main
```

### Step 2: Connect to Netlify

1. Go to [netlify.com](https://netlify.com) and sign in
2. Click **"Add new site"** → **"Import an existing project"**
3. Select **GitHub** and authorize access
4. Choose your repository
5. Netlify will auto-detect settings from `netlify.toml`:
   - Build command: `zola build`
   - Publish directory: `public`
6. Click **"Deploy site"**

### Step 3: Custom Domain (Optional)

1. In Netlify dashboard → **Site settings** → **Domain management**
2. Click **"Add custom domain"**
3. Follow DNS configuration instructions

### Updating Your Site

After making changes locally:
```powershell
git add .
git commit -m "Your update message"
git push
```
Netlify will automatically rebuild and deploy!

---

## File Reference

| File | Purpose |
|------|---------|
| `content/_index.md` | Homepage bio, education, social links |
| `publications.bib` | BibTeX source for publications |
| `config.toml` | Site configuration |
| `templates/base.html` | Base layout, navigation |
| `templates/index.html` | Homepage template |
| `sass/_components.scss` | Component styles |

---

## Tips

- **Your name is auto-highlighted** (bold + underline) in publication author lists
- **Tags are unified** across blog posts and publications
- **Homepage shows 5 recent publications**; see all on `/publications/`
- **Local files** use path `files/filename.pdf` → place in `static/files/`
