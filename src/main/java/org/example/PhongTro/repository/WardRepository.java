package org.example.PhongTro.repository;

import org.example.PhongTro.entity.Ward;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WardRepository extends JpaRepository<Ward, Long> {
    Optional<Ward> findByCode(String code);

    @Query("SELECT w FROM Ward w JOIN FETCH w.province WHERE w.province.id = :provinceId AND w.isDeleted = false ORDER BY w.name ASC")
    List<Ward> findByProvinceIdAndIsDeletedFalseOrderByNameAsc(@Param("provinceId") Long provinceId);

    @Query("SELECT w FROM Ward w JOIN FETCH w.province WHERE w.isDeleted = false ORDER BY w.name ASC")
    List<Ward> findAllByIsDeletedFalseOrderByNameAsc();

    @Query("SELECT w FROM Ward w JOIN FETCH w.province WHERE w.id = :id AND w.isDeleted = false")
    Optional<Ward> findByIdAndIsDeletedFalse(@Param("id") Long id);
}
