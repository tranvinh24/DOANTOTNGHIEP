package org.example.PhongTro.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.example.PhongTro.dto.request.WardRequestDto;
import org.example.PhongTro.dto.response.ApiResponse;
import org.example.PhongTro.dto.response.WardResponseDto;
import org.example.PhongTro.service.WardService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/wards")
@RequiredArgsConstructor
public class WardController {

    private final WardService wardService;

    @GetMapping
    public ApiResponse<List<WardResponseDto>> getAll(
            @RequestParam(required = false) Long provinceId) {
        return ApiResponse.<List<WardResponseDto>>builder()
                .message("Lấy danh sách xã/phường thành công")
                .result(wardService.getAll(provinceId))
                .build();
    }

    @GetMapping("/{id}")
    public ApiResponse<WardResponseDto> getById(@PathVariable Long id) {
        return ApiResponse.<WardResponseDto>builder()
                .message("Lấy thông tin xã/phường thành công")
                .result(wardService.getById(id))
                .build();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<WardResponseDto> create(@RequestBody @Valid WardRequestDto request) {
        return ApiResponse.<WardResponseDto>builder()
                .message("Tạo xã/phường thành công")
                .result(wardService.create(request))
                .build();
    }

    @PutMapping("/{id}")
    public ApiResponse<WardResponseDto> update(
            @PathVariable Long id,
            @RequestBody @Valid WardRequestDto request) {
        return ApiResponse.<WardResponseDto>builder()
                .message("Cập nhật xã/phường thành công")
                .result(wardService.update(id, request))
                .build();
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable Long id) {
        wardService.delete(id);
        return ApiResponse.<Void>builder()
                .message("Xóa xã/phường thành công")
                .build();
    }
}
