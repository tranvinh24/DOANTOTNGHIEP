package org.example.PhongTro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.example.PhongTro.enums.AgreementStatus;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "rental_agreements")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RentalAgreement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "rental_request_id")
    private RentalRequest rentalRequest;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "room_id", nullable = false)
    private Room room;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tenant_id", nullable = false)
    private User tenant;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "landlord_id", nullable = false)
    private User landlord;

    @Column(precision = 15, scale = 2)
    private BigDecimal price;

    @Column(precision = 15, scale = 2)
    private BigDecimal deposit;

    @Column(name = "start_date")
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    @Column(name = "terms_text", columnDefinition = "TEXT")
    private String termsText;

    @Column(name = "contract_file_url", length = 500)
    private String contractFileUrl;

    @Enumerated(EnumType.STRING)
    @Column(length = 50)
    private AgreementStatus status;

    @Column(name = "created_by_role", length = 50)
    private String createdByRole;

    @Column(name = "landlord_confirmed_at")
    private LocalDateTime landlordConfirmedAt;

    @Column(name = "tenant_confirmed_at")
    private LocalDateTime tenantConfirmedAt;

    @Builder.Default
    @Column(name = "is_deleted", nullable = false)
    private Boolean isDeleted = false;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}