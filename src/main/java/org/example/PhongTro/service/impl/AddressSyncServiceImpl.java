package org.example.PhongTro.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.PhongTro.entity.Province;
import org.example.PhongTro.entity.Ward;
import org.example.PhongTro.repository.ProvinceRepository;
import org.example.PhongTro.repository.WardRepository;
import org.example.PhongTro.service.AddressSyncService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class AddressSyncServiceImpl implements AddressSyncService {

    private static final String BASE_URL = "https://production.cas.so/address-kit/latest";

    private final ProvinceRepository provinceRepository;
    private final WardRepository wardRepository;
    private final RestTemplate restTemplate;

    @Override
    @Transactional
    public void syncAll() {
        log.info("[AddressSync] Bắt đầu đồng bộ dữ liệu địa chỉ từ Cas AddressKit...");

        syncProvinces();
        syncCommunes();

        log.info("[AddressSync] Đồng bộ hoàn tất.");
    }

    @SuppressWarnings("unchecked")
    private void syncProvinces() {
        Map<String, Object> response = restTemplate.getForObject(
                BASE_URL + "/provinces", Map.class);

        if (response == null || !response.containsKey("provinces")) {
            log.warn("[AddressSync] Không có dữ liệu tỉnh/thành phố từ API.");
            return;
        }

        List<Map<String, Object>> provinces = (List<Map<String, Object>>) response.get("provinces");
        int created = 0, skipped = 0;

        for (Map<String, Object> p : provinces) {
            String code = (String) p.get("code");
            String name = (String) p.get("name");

            if (code == null || name == null) continue;

            if (provinceRepository.findByCode(code).isPresent()) {
                skipped++;
                continue;
            }

            provinceRepository.save(Province.builder()
                    .code(code)
                    .name(name)
                    .isDeleted(false)
                    .build());
            created++;
        }

        log.info("[AddressSync] Tỉnh/thành: tạo mới={}, bỏ qua (đã tồn tại)={}", created, skipped);
    }

    @SuppressWarnings("unchecked")
    private void syncCommunes() {
        Map<String, Object> response = restTemplate.getForObject(
                BASE_URL + "/communes", Map.class);

        if (response == null || !response.containsKey("communes")) {
            log.warn("[AddressSync] Không có dữ liệu xã/phường từ API.");
            return;
        }

        List<Map<String, Object>> communes = (List<Map<String, Object>>) response.get("communes");
        int created = 0, skipped = 0, noProvince = 0;

        for (Map<String, Object> c : communes) {
            String code = (String) c.get("code");
            String name = (String) c.get("name");
            String provinceCode = (String) c.get("provinceCode");

            if (code == null || name == null || provinceCode == null) continue;

            if (wardRepository.findByCode(code).isPresent()) {
                skipped++;
                continue;
            }

            Province province = provinceRepository.findByCode(provinceCode).orElse(null);
            if (province == null) {
                log.warn("[AddressSync] Không tìm thấy tỉnh với mã={} cho xã={}", provinceCode, name);
                noProvince++;
                continue;
            }

            wardRepository.save(Ward.builder()
                    .code(code)
                    .name(name)
                    .province(province)
                    .isDeleted(false)
                    .build());
            created++;
        }

        log.info("[AddressSync] Xã/phường: tạo mới={}, bỏ qua={}, thiếu tỉnh={}", created, skipped, noProvince);
    }
}
