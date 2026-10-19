package org.example.PhongTro.service;

import org.example.PhongTro.dto.request.WardRequestDto;
import org.example.PhongTro.dto.response.WardResponseDto;

import java.util.List;

public interface WardService {
    WardResponseDto create(WardRequestDto request);
    WardResponseDto getById(Long id);
    List<WardResponseDto> getAll(Long provinceId);
    WardResponseDto update(Long id, WardRequestDto request);
    void delete(Long id);
}
