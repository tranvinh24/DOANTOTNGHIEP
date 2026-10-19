package org.example.PhongTro.entity;

import jakarta.persistence.*;
import lombok.*;
import org.example.PhongTro.enums.PaymentMethod;
import org.example.PhongTro.enums.PaymentStatus;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "payments")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Payment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "landlord_id", nullable = false)
    private User landlord;

    @Column(length = 50)
    private String type;

    @Column(name = "reference_id")
    private Long referenceId;

    @Column(precision = 15, scale = 2)
    private BigDecimal amount;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_method", length = 50)
    private PaymentMethod paymentMethod;

    @Enumerated(EnumType.STRING)
    @Column(length = 50)
    private PaymentStatus status;

    @Column(name = "provider_txn_id", length = 255)
    private String providerTxnId;

    @Column(name = "paid_at")
    private LocalDateTime paidAt;

    @Builder.Default
    @Column(name = "is_deleted", nullable = false)
    private Boolean isDeleted = false;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}