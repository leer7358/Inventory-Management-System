package com.inventory.service;

import com.inventory.model.Category;
import com.inventory.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryService {
    @Autowired
    private CategoryRepository repo;

    public List<Category> listAll() {
        return repo.findAll();
    }

    public void save(Category category) {
        repo.save(category);
    }

    public Category get(Long id) {
        return repo.findById(id).orElse(null);
    }

    public void delete(Long id) {
        repo.deleteById(id);
    }
}
