package org.example.PhongTro.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.*;
import java.io.Serializable;

@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Builder
public class ListingViewHistoryId implements Serializable {
    @Column(name = "tenant_id")
    private Long tenantId;

    @Column(name = "listing_id")
    private Long listingId;
}