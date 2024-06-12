# Aurelius Atlas Documentation

This repository contains the documentation for Aurelius Atlas Data Governance solution.

## Development Environment

To start using this development environment locally, follow the getting started guide for your preferred editor:

- [VS Code](https://code.visualstudio.com/docs/devcontainers/containers)
- [IntelliJ IDEA](https://www.jetbrains.com/help/idea/connect-to-devcontainer.html)
- [WebStorm](https://www.jetbrains.com/help/webstorm/connect-to-devcontainer.html)

> [!IMPORTANT]
> Please ensure [Docker](https://www.docker.com/) is installed and running on your machine.

If you prefer not to install and configure Docker locally, GitHub Codespaces offers a convenient alternative.
It allows you to create a fully configured development environment in the cloud. Please refer to the
[GitHub Codespaces documentation](https://docs.github.com/en/codespaces) to get started.

## How to Use

The documentation is built using [MkDocs](https://www.mkdocs.org/), a static site generator that's geared
towards project documentation. The documentation is written in Markdown, which is a lightweight markup language
with plain text formatting syntax. The Markdown files are located in the `docs` directory.

### Writing Documentation

To write documentation, create or edit Markdown files in the `docs` directory. You can use the Markdown syntax
to format your content. For more information on Markdown syntax, refer to the [Markdown Guide](https://www.markdownguide.org/).

### Configuration

The configuration for the documentation is stored in the `mkdocs.yml` file. This file contains the site name,
theme, navigation structure, and other settings for the documentation.

### Running a Local Documentation Server

To preview your documentation locally, you can run a local MkDocs server. Use the following command:

```bash
mkdocs serve
```

This command will start a local server at `http://127.0.0.1:8000/`, where you can see a live preview of your
documentation. Any changes made to the Markdown files will automatically refresh the preview.

### Building the Documentation

To generate a static site from your documentation, use the following command:

```bash
mkdocs build
```

This command compiles your documentation into static HTML files and places them in the `site` directory. You can
then deploy these files to any static site hosting service.

## Governance

Contributions to this repository are automatically verified using `pre-commit` hooks. The following pre-commit
hooks are enabled:

- `mdformat`: Automatically formats Markdown files according to the configuration in `.mdformat.toml`.
- `markdownlint`: Lints Markdown files to catch any remaining formatting issues and enforce style rules,
    configured via `.markdownlint.json`.
- `cspell`: Spell checks Markdown files to catch typographical errors, with settings defined in `.cspell.json`.

### On Commit

When you commit changes to this repository, the pre-commit hooks will run automatically. If any issues are found,
the commit will be rejected, and you will need to fix the issues before committing again.

> [!TIP]
> The `pre-commit` hooks are automatically installed in the development environment.

### On Merge

Pre-commit hooks are also run on GitHub Actions for every pull request or push to the `main` branch. This ensures
that all contributions meet the repository's standards before they are merged.
