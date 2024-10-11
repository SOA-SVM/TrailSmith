# TrailSmith

### Cloud Translation API

- **Elements:**
    - q (source texts)
    - target (target language)
    - translatedText
    - detectedSourceLanguage

- **Entites:**
    - Translations

## Install

## Setting up this script

- Create a personal Google Cloud API access token with `public_repo` scope
- Copy `config/secrets_example.yml` to `config/secrets.yml` and update token
- Ensure correct version of Ruby install (see `.ruby-version` for `rbenv`)
- Run `bundle install`

## Running this script

To create fixtures, run:

```shell
ruby lib/project_info.rb
```

Fixture data should appear in `spec/fixtures/` folder

