# flutterx_starter_kit

[![pub package](https://img.shields.io/pub/v/flutterx_starter_kit.svg)](https://pub.dev/packages/flutterx_starter_kit)
[![build](https://img.shields.io/github/actions/workflow/status/yourname/flutterx_starter_kit/dart.yml?branch=main)](https://github.com/yourname/flutterx_starter_kit/actions)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Starter kit **API client** berbasis `http` untuk Flutter/Dart:

- Inisialisasi mudah: `baseUrl`, `timeout`, `default headers`
- **Token dinamis** via `tokenProvider` (tidak membeku di awal)
- **Refresh token** opsional saat `401`
- Override per request (headers, query, baseUrl)
- Error handling sederhana (`ApiException`, `NetworkException`)

> Cocok untuk proyek multi-environment (dev/stg/prod) dan microservices.

---

## ✨ Fitur

- `ApiClient.init(ApiConfig(...))` → singleton siap pakai
- `get/post/put/patch/delete` mengembalikan `ApiResponse`
- Otomatis **Bearer** pada `Authorization`
- Fallback non-JSON body (jika server balas teks)
- Client injection → mudah di-mock untuk unit test

---

## 🚀 Instalasi

Tambahkan ke `pubspec.yaml` aplikasi Anda:

```yaml
dependencies:
  flutterx_starter_kit: ^0.1.0
