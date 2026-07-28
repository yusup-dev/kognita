# 07 — Security & Multi-Tenancy

## 1. Ancaman Utama

| Ancaman | Contoh | Mitigasi |
| ------- | ------ | -------- |
| Cross-tenant data leak | User A baca dokumen tenant B | Filter `tenant_id` dari JWT di setiap query |
| IDOR | Ganti UUID resource di URL | Cek kepemilikan + tenant sebelum return |
| Credential stuffing | Brute force login | Rate limit, lockout/policy, password hash kuat |
| Prompt injection | User manipulasi agent | Guardrails, tool allowlist, jangan eksekusi instruksi mentah |
| SSRF via tool | Tool fetch URL bebas | Batasi tool; allowlist |
| File malware upload | Upload executable | Validasi MIME/ukuran; scan opsional |
| Secret leak | API key di repo | Env vars, `.gitignore` |

---

## 2. Model Multi-Tenant

**Pilihan:** shared database + kolom `tenant_id` (lihat [04-data-model](./04-data-model.md)).

### Aturan wajib

1. `tenant_id` **hanya** dari Authentication principal (JWT claim), bukan dari request body/query yang bisa diganti klien.
2. Repository method bisnis menerima `tenantId` eksplisit.
3. Resource lintas aggregate (chunk, message) tetap diverifikasi lewat tenant.
4. Index Elasticsearch **wajib** punya field `tenant_id` dan filter pada setiap query.
5. Object key MinIO diawali `tenantId/…`.

### Pola service

```text
UUID tenantId = currentUser.getTenantId();
documentRepository.findByIdAndTenantId(id, tenantId)
  .orElseThrow(NotFoundException::new);
```

Mengembalikan **404** (bukan 403) untuk resource beda tenant mengurangi enumerasi.

---

## 3. Autentikasi (JWT)

### Claims usulan

```json
{
  "sub": "<userId>",
  "tenant_id": "<tenantId>",
  "role": "ADMIN",
  "email": "admin@acme.com",
  "iat": 0,
  "exp": 0
}
```

| Token | Lifetime usulan | Simpan |
| ----- | --------------- | ------ |
| Access | 15–60 menit | Memory klien |
| Refresh | 7–30 hari | HttpOnly cookie atau secure storage |

Password: BCrypt atau Argon2. Never log password / token penuh.

---

## 4. Otorisasi (RBAC)

| Endpoint group | ADMIN | USER | SUPPORT |
| -------------- | :---: | :---: | :---: |
| Kelola users | ✓ | | |
| Upload/hapus dokumen | ✓ | | |
| Update settings | ✓ | | |
| Chat | ✓ | ✓ | ✓ |
| Lihat tiket semua | ✓ | | ✓ |
| Lihat tiket sendiri | ✓ | ✓ | ✓ |
| Update status tiket | ✓ | | ✓ |
| Analytics | ✓ | | |

Fine-grained permission bisa ditambah nanti; mulai dari role sederhana.

Spring: `SecurityFilterChain` + `@PreAuthorize("hasRole('ADMIN')")` + tenant aspect/service checks.

---

## 5. Rate Limiting

| Scope | Contoh | Store |
| ----- | ------ | ----- |
| Per tenant | 100 req/menit API | Redis |
| Per user chat | 30 message/menit | Redis |
| Login | 10 attempt/15 menit / IP+email | Redis |

Response: `429` + header `Retry-After`.

---

## 6. Validasi Upload

- Extensi/MIME allowlist: `pdf`, `txt`, `md`, `docx` (sesuaikan).
- Max size dari `tenant_settings.max_upload_mb`.
- Jangan trust extension saja — deteksi content type.
- Simpan di MinIO private bucket; akses lewat API berauth, bukan URL publik permanen.

---

## 7. Keamanan AI / Agent

1. **System prompt** dikontrol admin; user message dipisah jelas di template.
2. **Tool calling:** hanya tools terdaftar; setiap tool enforce tenant + authz.
3. **Jangan** biarkan LLM menyusun SQL mentah.
4. **Output guardrails:** blok PII bocor (opsional), tolak jawaban di luar konteks bila policy ketat.
5. **Human escalation** untuk topik sensitif (HR, legal, medis — sesuai domain tenant).

---

## 8. OWASP API Top 10 (Mapping Singkat)

| Risiko | Kontrol Kognita |
| ------ | --------------- |
| Broken Object Level Auth | `findByIdAndTenantId` |
| Broken Auth | JWT + refresh rotation (usulan) |
| Broken Object Property Auth | DTO; jangan mass-assign role dari user biasa |
| Unrestricted Resource | Rate limit, max upload, timeout LLM |
| Security Misconfig | Disable debug di prod, secure headers |
| Sensitive Data Exposure | Hash password, no secrets in logs |
| SSRF | Tool network terbatas |
| Misaligned AuthZ | RBAC matrix |
| Inventory mismanagement | Versioned API `/v1` |
| Unsafe consumption of APIs | Validasi response LLM/tools |

---

## 9. Audit & Logging

Log yang berguna:

- `tenantId`, `userId`, `requestId` / `traceId`
- Aksi sensitif: login gagal, hapus dokumen, create ticket, tool call

Jangan log:

- Password, access token, isi dokumen penuh (kecuali level debug lokal), embedding vector besar

---

## 10. Checklist Sebelum Demo / Prod

- [ ] Semua query tenant-scoped tertutupi test
- [ ] Test IDOR negatif (beda tenant → 404)
- [ ] Secrets hanya di env
- [ ] CORS dikonfigurasi ketat
- [ ] Actuator endpoints dibatasi
- [ ] HTTPS di lingkungan publik
- [ ] Backup & retensi data didefinisikan
