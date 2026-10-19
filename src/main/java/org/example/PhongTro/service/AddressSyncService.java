package org.example.PhongTro.service;

/**
 * Đồng bộ tỉnh/thành phố và xã/phường từ Cas AddressKit API
 * GET https://production.cas.so/address-kit/latest/provinces
 * GET https://production.cas.so/address-kit/latest/communes
 */
public interface AddressSyncService {
    /**
     * Đồng bộ toàn bộ tỉnh/thành phố và xã/phường từ Cas AddressKit.
     * Bỏ qua nếu dữ liệu đã tồn tại (upsert theo code).
     */
    void syncAll();
}
