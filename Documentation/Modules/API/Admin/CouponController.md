# CouponController Module Documentation (API — Admin)

---

## Overview

### Purpose
Promotional coupons and cart discount management: CRUD operations for coupons, status toggling, and public cart coupon application/removal endpoints.

### Business Objective
Enable marketing campaigns, student incentives, and promotional discounts with configurable percentage or fixed-amount discounts, spending thresholds, usage limits, and expiration controls.

### Main Functionality
- List all coupons / get coupon by ID (AdminArea)
- Create / update / delete coupons (AdminArea)
- Toggle coupon active/inactive status (AdminArea)
- Apply coupon to cart (Anonymous / Authenticated)
- Remove coupon from cart (Anonymous / Authenticated)

### Primary User Roles

| Role | Description |
|------|-------------|
| AdminArea (any claim) | Full coupon CRUD and status toggle |
| Anonymous / Learner | Apply and remove coupons from current cart |

---

## Module Architecture

```
Presentation           API controllers (JSON)
Application            ICouponService -> CouponService
Storage                Coupons, CouponUsages, Carts tables
```

### Controllers

| Controller | Responsibility |
|-----------|----------------|
| `CouponController` | 7 actions (`api/Coupon`) — mixed authorization (AdminArea for management, AllowAnonymous for cart endpoints) |

### Services

| Service | Responsibility |
|---------|----------------|
| `CouponService` | Full CRUD, code uniqueness verification, discount calculation, cart discount application/removal, usage limit enforcement |

---

## Endpoints

**Route**: `api/Coupon`  
**Authorization**: mixed — see table

| # | Action | HTTP | Route | Auth | Description |
|---|--------|------|-------|------|-------------|
| 1 | GetAll | GET | `api/Coupon` | 🛡️ AdminArea | Retrieve all coupons |
| 2 | GetById | GET | `api/Coupon/{id:int}` | 🛡️ AdminArea | Retrieve coupon by ID |
| 3 | Create | POST | `api/Coupon` | 🛡️ AdminArea | Create new coupon with validation |
| 4 | Update | PUT | `api/Coupon/{id:int}` | 🛡️ AdminArea | Update coupon details and limits |
| 5 | Delete | DELETE | `api/Coupon/{id:int}` | 🛡️ AdminArea | Delete coupon |
| 6 | ToggleStatus | PATCH | `api/Coupon/{id:int}/toggle` | 🛡️ AdminArea | Toggle active / inactive status |
| 7 | ApplyCoupon | POST | `api/Coupon/apply` | 🔓 anonymous | Apply coupon to user/guest cart |
| 8 | RemoveCoupon | POST | `api/Coupon/remove` | 🔓 anonymous | Remove applied coupon from cart |

---

## Data Models & DTOs

### CreateCouponDto
- `Code`: string (required, 3-50 chars, auto-trimmed and uppercased)
- `Description`: string?
- `DiscountType`: `Percentage` (0) or `FixedAmount` (1)
- `DiscountValue`: decimal (> 0)
- `MaxDiscountAmount`: decimal? (applicable when percentage)
- `MinimumSpend`: decimal? (cart subtotal minimum threshold)
- `UsageLimit`: int? (global usage limit)
- `UsageLimitPerUser`: int? (per-user usage limit)
- `StartDate`: DateTime?
- `EndDate`: DateTime?
- `IsActive`: bool (default true)

### ApplyCouponResultDto
- `Success`: bool
- `Message`: string
- `CouponCode`: string?
- `DiscountAmount`: decimal
- `Subtotal`: decimal
- `TotalAmount`: decimal
