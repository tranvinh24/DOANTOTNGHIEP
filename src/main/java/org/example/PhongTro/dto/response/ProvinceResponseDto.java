package org.example.PhongTro.dto.response;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProvinceResponseDto {
    private Long id;
    private String code;
    private String name;
}
