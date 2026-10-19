package org.example.PhongTro.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.PhongTro.repository.ProvinceRepository;
import org.example.PhongTro.service.AddressSyncService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Slf4j
@Configuration
@RequiredArgsConstructor
public class AppConfig {

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    /**
     * Tự động đồng bộ địa chỉ khi khởi động nếu bảng provinces trống.
     */
    @Bean
    public CommandLineRunner addressSyncRunner(
            AddressSyncService addressSyncService,
            ProvinceRepository provinceRepository) {
        return args -> {
            if (provinceRepository.count() == 0) {
                log.info("[Startup] Bảng provinces trống - bắt đầu đồng bộ địa chỉ từ Cas AddressKit...");
                try {
                    addressSyncService.syncAll();
                } catch (Exception e) {
                    log.error("[Startup] Đồng bộ địa chỉ thất bại: {}", e.getMessage());
                }
            } else {
                log.info("[Startup] Bảng provinces đã có dữ liệu - bỏ qua đồng bộ tự động.");
            }
        };
    }
}
