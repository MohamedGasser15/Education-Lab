# CouponController Module Documentation (MVC — Admin Area)

---

## Overview

### Purpose
Admin interface for managing promotional codes and discount coupons, featuring live interactive ticket previews, stats cards, filtering, and SweetAlert2 confirmation dialogs.

### Business Objective
Give platform administrators a centralized, intuitive interface to create, monitor, configure, and disable promotional discount codes across marketing campaigns.

### Main Functionality
- Real-time statistics cards (Total Coupons, Active, Total Uses, Inactive/Expired)
- Live search and status filter toolbar
- Interactive coupon table with one-click copy, status toggle switch, and edit/delete actions
- Redesigned modal with live ticket preview, visual discount type switcher, and quick expiry presets
- Multi-lingual localization support (Arabic RTL & English LTR)
- Role-based permissions integration (`AdminClaims.Coupons.*`)

### Primary User Roles

| Role | Description |
|------|-------------|
| Admin (`AdminClaims.Coupons.ViewCoupons`) | View coupons index and statistics |
| Admin (`AdminClaims.Coupons.CreateCoupon`) | Create new promotional coupons |
| Admin (`AdminClaims.Coupons.EditCoupon`) | Edit coupon details and toggle active status |
| Admin (`AdminClaims.Coupons.DeleteCoupon`) | Delete promotional coupons |

---

## Module Architecture

```
Presentation           Areas/Admin/Views/Coupon/Index.cshtml
Application            ICouponService -> CouponService
External               EduLab API: GET api/Coupon, GET api/Coupon/{id},
                       POST api/Coupon, PUT api/Coupon/{id},
                       DELETE api/Coupon/{id}, PATCH api/Coupon/{id}/toggle
```

### Controllers

| Controller | Responsibility |
|-----------|----------------|
| `CouponController` | Index view + AJAX endpoints (GetCoupon, Create, Update, Delete, ToggleStatus) |

### Services

| Service | Responsibility |
|---------|----------------|
| `CouponService` | Wraps API endpoints `api/Coupon` via `AuthorizedHttpClientService` |

### Dependencies on Other Modules
- **Admin Layout**: sidebar link (`fas fa-ticket-alt`) guarded by `AdminClaims.Coupons.ViewCoupons`.
- **Role Permissions**: `ManagePermissions.cshtml` includes the `Coupons` claim group.
- **SharedResources**: localized labels across all 20 language `.resx` files.
- **EduLab API**: backend REST API controller (`api/Coupon`).

---

## Folder Structure

```
Areas/Admin/
├── Controllers/
│   └── CouponController.cs           # 6 actions (Index, GetCoupon, Create, Update, Delete, ToggleStatus)
└── Views/
    └── Coupon/
        └── Index.cshtml              # Main coupon management view with modal & live ticket preview
```

---

## UI Components & Key Features

### 1. Stats Cards
- **Total Coupons**: overall coupon count.
- **Active Coupons**: currently active and valid coupons.
- **Total Uses**: total redemption count across all coupons.
- **Inactive / Expired**: coupons requiring administrative attention.

### 2. Live Interactive Modal (`#couponModal`)
- **Card Preview**: dynamically updates card color, discount value (`%` or fixed amount), coupon code, spending threshold, and validity dates in real time.
- **Discount Type Cards**: visual segmented switcher between Percentage and Fixed Amount with dynamic toggling of the "Max Discount" field.
- **Quick Expiry Presets**: buttons for quick validity setup (`+7 Days`, `+30 Days`, `No Expiry ∞`).
- **Auto Code Generator**: generates random uppercase marketing codes (e.g. `SUMMER-2026`).
- **Date Validation**: min-date restriction preventing selection of past dates for expiration.
