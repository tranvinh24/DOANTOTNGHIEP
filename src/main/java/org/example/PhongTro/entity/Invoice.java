package org.example.PhongTro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "invoices")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "payment_id", nullable = false)
    private Payment payment;

    @Column(length = 50)
    private String type;

    @Column(name = "service_package_id")
    private Long servicePackageId;

    @Column(name = "invoice_no", length = 100)
    private String invoiceNo;

    @Column(name = "tax_amount", precision = 15, scale = 2)
    private BigDecimal taxAmount;

    @Column(name = "total_amount", precision = 15, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "buyer_name", length = 255)
    private String buyerName;

    @Column(name = "buyer_tax_code", length = 100)
    private String buyerTaxCode;

    @Column(name = "issued_at")
    private LocalDateTime issuedAt;

    @Builder.Default
    @Column(name = "is_deleted", nullable = false)
    private Boolean isDeleted = false;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}