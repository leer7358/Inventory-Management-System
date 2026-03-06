package com.inventory.repository;

import com.inventory.model.Item;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ItemRepository extends JpaRepository<Item, Long> {

    /**
     * Search items by name or category name (case-insensitive, partial match).
     * Uses JPQL to avoid method-name pitfalls across different domain models.
     */
    @Query("SELECT i FROM Item i " +
            "LEFT JOIN i.category c " +
            "WHERE LOWER(i.name) LIKE LOWER(CONCAT('%', :q, '%')) " +
            "   OR (c IS NOT NULL AND LOWER(c.name) LIKE LOWER(CONCAT('%', :q, '%')))")
    List<Item> searchByNameOrCategory(@Param("q") String q);

    /**
     * Count items whose quantity is less than or equal to the given threshold.
     * Spring Data will implement this automatically.
     */
    long countByQuantityLessThanEqual(int quantity);
}