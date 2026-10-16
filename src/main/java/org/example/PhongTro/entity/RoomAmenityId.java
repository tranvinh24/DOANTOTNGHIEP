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
public class RoomAmenityId implements Serializable {
    @Column(name = "room_id")
    private Long roomId;

    @Column(name = "amenity_id")
    private Long amenityId;
}