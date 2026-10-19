package org.example.PhongTro.controller;

import lombok.RequiredArgsConstructor;
import org.example.PhongTro.dto.response.ApiResponse;
import org.example.PhongTro.dto.response.ProvinceResponseDto;
import org.example.PhongTro.entity.Province;
import org.example.PhongTro.repository.ProvinceRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/provinces")
@RequiredArgsConstructor
public class ProvinceController {

    private final ProvinceRepository provinceRepository;

    @GetMapping
    public ApiResponse<List<ProvinceResponseDto>> getAll() {
        List<ProvinceResponseDto> result = provinceRepository
                .findAllByIsDeletedFalseOrderByNameAsc()
                .stream()
                .map(p -> ProvinceResponseDto.builder()
                        .id(p.getId())
                        .code(p.getCode())
                        .name(p.getName())
                        .build())
                .toList();

        return ApiResponse.<List<ProvinceResponseDto>>builder()
                .message("Lấy danh sách tỉnh/thành phố thành công")
                .result(result)
                .build();
    }
}
