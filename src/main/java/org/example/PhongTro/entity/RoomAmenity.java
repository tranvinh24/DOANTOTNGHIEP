package org.example.PhongTro.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "room_amenities")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RoomAmenity {
    @EmbeddedId
    private RoomAmenityId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("roomId")
    @JoinColumn(name = "room_id")
    private Room room;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("amenityId")
    @JoinColumn(name = "amenity_id")
    private Amenity amenity;

    @Builder.Default
    @Column(name = "is_deleted", nullable = false)
    private Boolean isDeleted = false;
}
