package com.inventory.model;

import jakarta.persistence.*;

@Entity
@Table(name = "settings")
public class Settings {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "low_stock_threshold")
    private int lowStockThreshold;

    public Settings() {}

    public Settings(int lowStockThreshold) {
        this.lowStockThreshold = lowStockThreshold;
    }

    public Long getId() {
        return id;
    }

    public int getLowStockThreshold() {
        return lowStockThreshold;
    }

    public void setLowStockThreshold(int lowStockThreshold) {
        this.lowStockThreshold = lowStockThreshold;
    }
}
