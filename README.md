# Capistrano::Scm::S3

Grabs compressed source in tarball from S3.

Assumes your instance has an associated IAM role (or credentials on the host) to be able to copy down from S3.

```ruby
group :development do
  gem "capistrano", "~> 3.7", require: false
  gem 'capistrano-scm-s3', '~> 0.1.7', git: 'https://github.com/tarrynn/capistrano-scm-s3.git'
end
```

```
bundle install
```

In `config/deploy.rb`:

```ruby
set :branch, 'staging'
set :application, 'app-name'
set :stage, 'stage'
set :scm_s3_bucket, 's3://path/to/bucket'
```

Expects source tarball to be in `#{fetch :scm_s3_bucket}/#{fetch :stage}/#{fetch :branch}_source.tar.gz`

It downloads the tarball into `/tmp/bootup`, extracts it there, moves contents into `release_path` then removes `/tmp/bootup`
