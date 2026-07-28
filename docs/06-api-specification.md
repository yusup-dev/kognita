# 06 — Spesifikasi API

Base URL (dev): `http://localhost:8080/api/v1`

Auth: `Authorization: Bearer <access_token>` kecuali endpoint publik.

Format error usulan (Problem Details / envelope konsisten):

```json
{
  "timestamp": "2026-07-28T01:00:00Z",
  "status": 400,
  "error": "Bad Request",
  "message": "Validation failed",
  "path": "/api/v1/documents",
  "details": [
    { "field": "file", "message": "must not be empty" }
  ]
}
```

---

## 1. Auth

### `POST /auth/register`

Registrasi tenant + admin pertama.

**Body**

```json
{
  "organizationName": "Acme Corp",
  "email": "admin@acme.com",
  "password": "Secret123!",
  "fullName": "Ada Admin"
}
```

**Response `201`**

```json
{
  "tenantId": "…",
  "userId": "…",
  "accessToken": "…",
  "refreshToken": "…",
  "tokenType": "Bearer",
  "expiresIn": 3600
}
```

### `POST /auth/login`

```json
{
  "email": "admin@acme.com",
  "password": "Secret123!"
}
```

> Jika email unik per tenant, tambahkan `organizationSlug` pada login.

### `POST /auth/refresh`

```json
{ "refreshToken": "…" }
```

---

## 2. Users (Admin)

| Method | Path | Deskripsi |
| ------ | ---- | --------- |
| `GET` | `/users` | List user tenant |
| `POST` | `/users` | Buat user |
| `GET` | `/users/{id}` | Detail |
| `PATCH` | `/users/{id}` | Update role/status/nama |
| `DELETE` | `/users/{id}` | Disable / hapus soft |

**POST body**

```json
{
  "email": "user@acme.com",
  "password": "Temp123!",
  "fullName": "Bob User",
  "role": "USER"
}
```

---

## 3. Documents

| Method | Path | Deskripsi | Fase |
| ------ | ---- | --------- | ---- |
| `POST` | `/documents` | Upload (`multipart/form-data`) | 1 |
| `GET` | `/documents` | List (filter status, pagination) | 1 |
| `GET` | `/documents/{id}` | Detail metadata | 1 |
| `DELETE` | `/documents/{id}` | Hapus | 1 |
| `POST` | `/documents/{id}/reprocess` | Trigger ulang ingestion | 3 |

**Upload**

- `file`: binary
- optional `title`, `tags`

**Response**

```json
{
  "id": "…",
  "filename": "policy.pdf",
  "status": "UPLOADED",
  "sizeBytes": 204800,
  "createdAt": "…"
}
```

---

## 4. Tenant Settings

| Method | Path | Deskripsi | Fase |
| ------ | ---- | --------- | ---- |
| `GET` | `/settings` | Ambil setting tenant | 2 |
| `PUT` | `/settings` | Update system prompt, rate limit, dll | 2 |

```json
{
  "systemPrompt": "You are Acme support assistant. Answer only from provided context.",
  "llmModel": "llama3.1",
  "rateLimitPerMinute": 30
}
```

---

## 5. Conversations & Chat

| Method | Path | Deskripsi | Fase |
| ------ | ---- | --------- | ---- |
| `POST` | `/conversations` | Buat conversation | 2 |
| `GET` | `/conversations` | List milik user | 2 |
| `GET` | `/conversations/{id}` | Detail + messages | 2 |
| `POST` | `/conversations/{id}/messages` | Kirim pesan (bisa non-stream) | 2 |
| `POST` | `/conversations/{id}/messages:stream` | Chat SSE | 2 |

### Stream (SSE)

**Request**

```json
{
  "content": "Apa kebijakan cuti tahunan?"
}
```

**Events (contoh)**

```
event: token
data: {"text":"Menurut"}

event: token
data: {"text":" dokumen"}

event: citation
data: {"documentId":"…","filename":"policy.pdf","score":0.82}

event: done
data: {"messageId":"…"}
```

`Content-Type: text/event-stream`

---

## 6. Search (internal / admin debug)

| Method | Path | Deskripsi | Fase |
| ------ | ---- | --------- | ---- |
| `POST` | `/search` | Hybrid search chunks | 3 |

```json
{
  "query": "cuti tahunan",
  "topK": 5
}
```

Response berisi chunk + score + document metadata. Selalu scoped ke tenant token.

---

## 7. Tickets

| Method | Path | Deskripsi | Fase |
| ------ | ---- | --------- | ---- |
| `GET` | `/tickets` | List tiket tenant | 4 |
| `GET` | `/tickets/{id}` | Detail | 4 |
| `PATCH` | `/tickets/{id}` | Update status/assignee | 4 |
| `POST` | `/tickets` | Buat manual (non-agent) | 4 |

Agent membuat tiket lewat tool internal, bukan wajib lewat endpoint publik chat.

---

## 8. Analytics

| Method | Path | Deskripsi | Fase |
| ------ | ---- | --------- | ---- |
| `GET` | `/analytics/overview` | Ringkasan: docs, chats, tickets, usage | 4 |

```json
{
  "documentsReady": 12,
  "conversationsThisWeek": 40,
  "openTickets": 3,
  "tokensUsedThisMonth": 125000
}
```

---

## 9. Health

| Method | Path | Auth |
| ------ | ---- | ---- |
| `GET` | `/actuator/health` | publik / terbatas |
| `GET` | `/actuator/prometheus` | internal |

---

## 10. Kode Status Umum

| Kode | Arti |
| ---- | ---- |
| 200 | OK |
| 201 | Created |
| 400 | Validasi gagal |
| 401 | Belum auth / token invalid |
| 403 | Auth OK tapi tidak berhak |
| 404 | Resource tidak ada **atau** beda tenant (jangan bocorkan) |
| 409 | Konflik (email, slug) |
| 429 | Rate limited |
| 500 | Error server |
| 503 | Dependency (LLM/DB) down |

---

## 11. Pagination & Sorting

Query standar:

- `page` (0-based), `size` (default 20, max 100)
- `sort=createdAt,desc`

Response:

```json
{
  "content": [ … ],
  "page": 0,
  "size": 20,
  "totalElements": 100,
  "totalPages": 5
}
```

---

## 12. Versioning & Kompatibilitas

- Prefix `/api/v1`.
- Breaking change → `/api/v2` atau field baru yang backward compatible.
- Jangan expose entity JPA mentah; selalu DTO.
