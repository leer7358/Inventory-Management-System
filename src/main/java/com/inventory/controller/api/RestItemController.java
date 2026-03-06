package com.inventory.controller.api;

import com.inventory.model.Item;
import com.inventory.service.ItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/items")
public class RestItemController {
    @Autowired private ItemService service;

    @GetMapping
    public List<Item> getAll() { return service.listAll(); }

    @PostMapping
    public void addItem(@RequestBody Item item) { service.save(item); }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) { service.delete(id); }
}
