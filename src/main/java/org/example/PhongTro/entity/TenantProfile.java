package org.example.PhongTro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "tenant_profiles")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TenantProfile {
    @Id
    @Column(name = "user_id")
    private Long userId;

    @OneToOne(fetch = FetchType.LAZY)
    @MapsId
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "desired_province_id")
    private Province desiredProvince;

    @Column(name = "price_min", precision = 15, scale = 2)
    private BigDecimal priceMin;

    @Column(name = "price_max", precision = 15, scale = 2)
    private BigDecimal priceMax;

    @Column(name = "area_min", precision = 10, scale = 2)
    private BigDecimal areaMin;

    @Column(name = "area_max", precision = 10, scale = 2)
    private BigDecimal areaMax;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "desired_room_type_id")
    private RoomType desiredRoomType;

    @Builder.Default
    @Column(name = "is_deleted", nullable = false)
    private Boolean isDeleted = false;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}