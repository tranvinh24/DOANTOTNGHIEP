package org.example.PhongTro.service.impl;

import lombok.RequiredArgsConstructor;
import org.example.PhongTro.dto.request.WardRequestDto;
import org.example.PhongTro.dto.response.WardResponseDto;
import org.example.PhongTro.entity.Province;
import org.example.PhongTro.entity.Ward;
import org.example.PhongTro.exception.AppException;
import org.example.PhongTro.exception.ErrorCode;
import org.example.PhongTro.repository.ProvinceRepository;
import org.example.PhongTro.repository.WardRepository;
import org.example.PhongTro.service.WardService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class WardServiceImpl implements WardService {

    private final WardRepository wardRepository;
    private final ProvinceRepository provinceRepository;

    @Override
    @Transactional
    public WardResponseDto create(WardRequestDto request) {
        Province province = provinceRepository.findById(request.getProvinceId())
                .orElseThrow(() -> new AppException(ErrorCode.RESOURCE_NOT_FOUND));

        Ward ward = Ward.builder()
                .code(request.getCode())
                .name(request.getName())
                .province(province)
                .isDeleted(false)
                .build();

        return toDto(wardRepository.save(ward));
    }

    @Override
    public WardResponseDto getById(Long id) {
        Ward ward = wardRepository.findByIdAndIsDeletedFalse(id)
                .orElseThrow(() -> new AppException(ErrorCode.RESOURCE_NOT_FOUND));
        return toDto(ward);
    }

    @Override
    public List<WardResponseDto> getAll(Long provinceId) {
        List<Ward> list = (provinceId != null)
                ? wardRepository.findByProvinceIdAndIsDeletedFalseOrderByNameAsc(provinceId)
                : wardRepository.findAllByIsDeletedFalseOrderByNameAsc();
        return list.stream().map(this::toDto).toList();
    }

    @Override
    @Transactional
    public WardResponseDto update(Long id, WardRequestDto request) {
        Ward ward = wardRepository.findByIdAndIsDeletedFalse(id)
                .orElseThrow(() -> new AppException(ErrorCode.RESOURCE_NOT_FOUND));

        Province province = provinceRepository.findById(request.getProvinceId())
                .orElseThrow(() -> new AppException(ErrorCode.RESOURCE_NOT_FOUND));

        ward.setCode(request.getCode());
        ward.setName(request.getName());
        ward.setProvince(province);

        return toDto(wardRepository.save(ward));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Ward ward = wardRepository.findByIdAndIsDeletedFalse(id)
                .orElseThrow(() -> new AppException(ErrorCode.RESOURCE_NOT_FOUND));
        ward.setIsDeleted(true);
        wardRepository.save(ward);
    }

    private WardResponseDto toDto(Ward ward) {
        return WardResponseDto.builder()
                .id(ward.getId())
                .code(ward.getCode())
                .name(ward.getName())
                .provinceId(ward.getProvince() != null ? ward.getProvince().getId() : null)
                .provinceName(ward.getProvince() != null ? ward.getProvince().getName() : null)
                .build();
    }
}
