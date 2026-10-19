package org.example.PhongTro.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WardRequestDto {
    @NotNull(message = "INVALID_INPUT")
    private Long provinceId;

    @NotBlank(message = "INVALID_INPUT")
    private String code;

    @NotBlank(message = "INVALID_INPUT")
    private String name;
}
