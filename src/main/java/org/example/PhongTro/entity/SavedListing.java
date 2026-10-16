package org.example.PhongTro.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "saved_listings")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SavedListing {
    @EmbeddedId
    private SavedListingId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("tenantId")
    @JoinColumn(name = "tenant_id")
    private User tenant;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("listingId")
    @JoinColumn(name = "listing_id")
    private Listing listing;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}