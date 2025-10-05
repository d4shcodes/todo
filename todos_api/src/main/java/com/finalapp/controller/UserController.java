package com.finalapp.controller;

import com.finalapp.model.User;
import com.finalapp.repository.UserRepository;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/api/users")
public class UserController {
    private final UserRepository repository;

    public UserController(UserRepository repository) {
        this.repository = repository;
    }

    // @GetMapping
    // public List<User> getAll() {
    //     return repository.findAll();
    // }

    // @PostMapping
    // public User create(@RequestBody User user) {
    //     return repository.save(user);
    // }

    @GetMapping("/{id}")
    public User getById(@PathVariable Long id) {
        return repository.findById(id).orElseThrow();
    }

    // @DeleteMapping("/{id}")
    // public void delete(@PathVariable Long id) {
    //     repository.deleteById(id);
    // }
}
