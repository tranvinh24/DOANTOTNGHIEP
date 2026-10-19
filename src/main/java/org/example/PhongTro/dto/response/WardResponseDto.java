package org.example.PhongTro.dto.response;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WardResponseDto {
    private Long id;
    private Long provinceId;
    private String provinceName;
    private String code;
    private String name;
}
