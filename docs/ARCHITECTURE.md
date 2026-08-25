# WorkHub — Architecture & Design Document

This document explains the design decisions, architecture, and deployment strategy of the WorkHub application. It's written to help you explain the project confidently in an interview.

---

## 1. Overview

WorkHub is a **monolithic Rails 8 application** that serves four product areas from a single codebase:

1. **Job Board** — Clients create companies and post jobs; freelancers apply.
2. **Marketplace** — Users sell digital products; buyers place orders.
3. **Blog** — Users write posts in categories; readers comment.
4. **Project Management** — Users create projects and track tasks.

A monolith is the right choice here because the domains share a single `User` model and authentication boundary, and it keeps deployment simple — a key interview point.

## 2. Request Lifecycle

```
Browser
  │  HTTP request
  ▼
Thruster (production) / Puma (dev)
  │
  ▼
Rails Router (config/routes.rb)
  │
  ▼
Controller (app/controllers)
  │  authenticate_user! (Devise)
  │  authorize (Pundit)
  ▼
Model (ActiveRecord) ──► PostgreSQL
  │
  ▼
View (ERB + Tailwind) ──► HTML response
```

## 3. Authentication & Authorization

### Authentication (Devise)
- Handles signup, login, logout, password reset, and session management.
- Passwords hashed with **bcrypt**.
- Custom `RegistrationsController` permits `name` and `role` at signup.

### Authorization (Pundit)
- Policies in `app/policies/` define who can do what.
- Example: `JobPolicy#create?` returns true only for `client` or `admin` users.
- `ApplicationController` rescues `Pundit::NotAuthorizedError` and redirects with a flash message.

## 4. Data Model

### Core Entities

- **User** — polymorphic actor with `role` enum (`user`/`client`/`admin`).
- **Company** — belongs to a client user; has many jobs.
- **Job** — belongs to a company; has many applications; `status` and `employment_type` enums.
- **JobApplication** — join between user and job; unique per (job, user).

### Commerce

- **Category** — shared taxonomy for products and posts.
- **Product** — belongs to a user and category; has a decimal price.
- **Order** — belongs to a user; has many order items; `status` enum.
- **OrderItem** — join between order and product; stores quantity and price snapshot.

### Blog

- **Post** — belongs to a user and category; `published` boolean.
- **Comment** — belongs to a post and user.

### Projects

- **Project** — belongs to a user; `status` enum; computes `progress_percentage`.
- **Task** — belongs to a project and user; `status` and `priority` enums; optional due date.

## 5. Key Design Patterns

### Enums
Rails enums map integers to named states, giving type safety and readable scopes:
```ruby
enum :status, { draft: 0, published: 1, closed: 2 }, default: :draft
```

### Scopes
Common queries are encapsulated:
```ruby
scope :published, -> { where(status: :published) }
scope :recent, -> { order(created_at: :desc) }
```

### Ransack Allowlisting
Searchable attributes are explicitly allowlisted to prevent exposing sensitive columns:
```ruby
def self.ransackable_attributes(auth_object = nil)
  %w[title description location ...]
end
```

## 6. Testing

- **Minitest** with fixtures.
- Model tests cover validations, enums, scopes, and business logic (e.g., `progress_percentage`).
- CI runs tests, RuboCop, Brakeman, and bundler-audit.

## 7. Deployment (AWS)

### Architecture

```
Internet
   │
   ▼
AWS EC2 (Ubuntu)
   │
   ├── Docker container: WorkHub app (Puma + Thruster)
   ├── Docker container: PostgreSQL 16 (accessory)
   └── Docker volume: persistent DB data
```

### Steps

1. **Provision EC2** — Ubuntu 22.04, security group opening ports 22 (SSH), 80 (HTTP), 443 (HTTPS).
2. **Configure Kamal** — `config/deploy.yml` points to the server and GHCR registry.
3. **Set secrets** — `.kamal/secrets` holds `RAILS_MASTER_KEY`, `DB_PASSWORD`, `KAMAL_REGISTRY_PASSWORD`.
4. **Deploy** — `bin/kamal setup` then `bin/kamal deploy`.

### Alternative: AWS ECS
The `Dockerfile` is ECS-compatible. Push the image to ECR and run a task with:
- **Task definition** with the web container on port 3000.
- **RDS PostgreSQL** as the database (set `DB_HOST`, `DB_USERNAME`, `DB_PASSWORD`).
- **Application Load Balancer** in front of the service.

## 8. Environment Variables

See `.env.example` for the full list. Key ones:

| Variable | Purpose |
|----------|---------|
| `RAILS_MASTER_KEY` | Decrypts `config/credentials.yml.enc` |
| `DB_HOST` | Database host (default `localhost`) |
| `DB_USERNAME` | Database user (default `postgres`) |
| `DB_PASSWORD` | Database password |
| `DB_NAME` | Database name (default `showcase_app_production`) |
| `SECRET_KEY_BASE` | Rails secret key base (production) |
