package org.example.PhongTro.controller;

import lombok.RequiredArgsConstructor;
import org.example.PhongTro.dto.response.ApiResponse;
import org.example.PhongTro.service.AddressSyncService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/sync")
@RequiredArgsConstructor
public class AddressSyncController {

    private final AddressSyncService addressSyncService;

    /**
     * POST /api/v1/sync/address
     * Trigger đồng bộ thủ công tỉnh/thành phố và xã/phường từ Cas AddressKit.
     */
    @PostMapping("/address")
    public ApiResponse<Void> syncAddress() {
        addressSyncService.syncAll();
        return ApiResponse.<Void>builder()
                .message("Đồng bộ địa chỉ hoàn tất")
                .build();
    }
}
